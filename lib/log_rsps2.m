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

function [h] = log_rsps2(sys,s)
% This is a program for calculating the log10 response of a zpk system.

[z,p,k] = zpkdata(sys, 'v'); % Find the zeros and poles
ls = length(s); % Find the number of frequency points
h = ones(1,ls); % More convenient for loop below
h = h*log2(k);
for i_ = 1:length(z)
  zs = s - z(i_);
  zs(find(zs == 0)) = 10*eps;
  h = h + log2(zs);
end
for i_ = 1:length(p)
  ps = s - p(i_);
  ps(find(ps == 0)) = 10*eps;
  h = h - log2(ps);
end
[h] = log10(abs(pow2(h))); % convert log2 to log10
