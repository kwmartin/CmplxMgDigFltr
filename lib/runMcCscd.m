function xout1 = runMcCscd(cscdFltr, wp, std, fShft, nmbRuns, ylim, color)
% runMcCscd(cscdFltr, wp, std, fShft, nmbRuns, ylim, color)
% run nmbRuns and plot FFTs of impulse responses of cascade filter
% having randomly perturbed matrices. cscdFltr is object of cascadeClass,
% std is standard deviation of perturbations, fShft is an optional
% frequency shift of filters, and ylim is limits on y of plots
% color is an optional color string (defaults to 'b').
% A slower but cleaner alternative is runMcCscd2() that uses the
% cascadeClass.sim() function
%   Complex Filter Design Programs

%   Copyright (C) 2026  Kenneth Martin

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.

%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

  if nargin < 7 || isempty(color)
    color = 'b';
  end

  A_ = {};
  B_ = {};
  C_ = {};
  D_ = {};
  for i_ = 1:cscdFltr.size
    sys = cscdFltr.sctns(i_).sys;
    [a b c d] = ssdata(sys);
    A_{i_} = a;
    B_{i_} = b;
    C_{i_} = c;
    D_{i_} = d;
  end

  xin = zeros(8192,1);
  xin(1) = 1;
  freq_shtf = fShft;
  xout1 = simBiquad(A_, B_, C_, D_ , xin, freq_shtf);

  % hndl(6) = figure('Position',[800 100 600 600]);
  [ax1 ax2, f, ymRef] = plotRspns(xout1, wp + freq_shtf, color, ylim);
  errs = zeros(size(ymRef));
  %[f, ndB, dB, ym, ya] = nfft2(xout1,'b', -120, 2);

  hold(ax1, 'on');
  hold(ax2, 'on');
  for runNo=1:nmbRuns
    for i_ = 1:size(A_, 2)
      N = size(A_{i_}, 1);
      rMtrx = rndmMtrx(std, N);
      A_2{i_} = rMtrx*A_{i_};
      rMtrx = rndmMtrx(std, N);
      B_2{i_} = rMtrx*B_{i_};
      rMtrx = rndmMtrx(std, N);
      C_2{i_} = C_{i_}*rMtrx;
      rMtrx = rndmMtrx(std, 1);
      D_2{i_} = rMtrx*D_{i_};
    end

    xout2 = simBiquad(A_2, B_2, C_2, D_2, xin, freq_shtf);
    [ax1 ax2, f, ym] = plotRspns(xout2, wp + freq_shtf, color, ylim);
    errs = errs + (ym - ymRef).^2;
    %[f, ndB, dB, ym, ya] = nfft2(xout2,'r', minY, 2);
  end
  sumErrs = sqrt(sum(errs));
  fprintf('Monte-Carlo standard deviation of errors: %0.5g\n', ...
      sumErrs);
  pltMx = max(0.5*db(errs)) + 2;
  % plot_errs(f, 0.5*db(errs), 'b', [-0.5, 0.5, ylim(1), pltMx]);
