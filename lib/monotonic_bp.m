function Fltr = monotonic_bp(ps,wp,ni,e_)
% ni: number of loss poles at infinity
% ps: finite jw loss poles
% w1: lower passband edge
% w2: upper passband edge
% e_: passband ripple = sqrt(1 + e_^2)
%
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

np=length(ps); % number of finite loss poles (including zero)

% transform loss poles to s-plane and calculate denominator of H(s)
% which is the numerator of transfer function T(s)
pz = zpk([],[],1);
for i_ = 1:np % Find transformed finite jw axis poles
    wpp(i_) = trnsfrm_wp(ps(i_),wp); % wpp(i) is equal to pi^2
    pp(i_) = zpk(tf([1 2*sqrt(wpp(i_)) wpp(i_)],1));
    pz = pz* pp(i_);
end
for i_ = 1:ni % Find transformed poles at infinity
    pi(i_) = zpk(tf([1 2 1],1));
    pz = pz*pi(i_);
end
N = np + ni;
P = pz.z{1};
% The frequency of all reflection zeros is equal to the geometric average
% of the loss-poles
fz0 = prod(P)^(1/(2*N));
fz1 = zpk(j*[fz0 -fz0], [], 1);
fz = fz1^(N); % There are N = np + ni reflection zeros

% transform fz back to w plane
z = fz.z{1,1};
nz = length(z)/2;
for i_ = 1:nz
    z2(i_) = z(2*i_ - 1)*z(2*i_);
    wf(i_) = trnsfrm_yf(z2(i_),wp);
end
wf = wf.';

% find H by solving Feldtkeller's equation in the s domain
K = zpk(wf, ps, 1.0);
KK_ = K*K';
k = 1.0/abs(freqresp(K,wp(1)));
% The following commented out line worked in 2004, but not in 2016
% The replacement is a hack that seems to get around Matlab limitations handling
% complex coefficient transfer functions
%HH_ = 1 + e_^2*k^2*KK_;
HH_ = zpk(1 + tf(e_^2*k^2*KK_));

% choose LHP poles (which are zeros of HH_)
hh_z = HH_.z{1,1};
n = ni + np;
k = 1;
for i_ = 1:2*n
    if real(hh_z(i_)) < 0
        we(k) = hh_z(i_);
        k = k+1;
    end
end

% finally form and normalize gain
H = zpk(we,ps,1);
g = sqrt(1.0 + e_^2)/abs(freqresp(H,wp(1)));
H = g*H;
E = we;
F = wf.';
P = ps;
Fltr = struct('H', H, 'E', E, 'F', F, 'P', P);
