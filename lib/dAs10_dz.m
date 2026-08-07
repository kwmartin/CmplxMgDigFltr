function h = dAs10_dz(wsz,As,w)
%   h = dAs10_dz(wsz,As,w) finds derivate of stopband specs using simple
%   interpolation of specifications in log10 to the transformed variable z
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

As = As/10.0;
ls = length(w);
h = zeros(ls,1); % More convenient for loop below

for i_ = 1:ls
    if w(i_)~= wsz(1)
        w1(i_) = w(i_) - 1e-5;
    else
        w1(i_) = w(i_);
    end

    if w(i_)~= wsz(length(wsz))
        w2(i_) = w(i_) + 1e-5;
    else
        w2(i_) = w(i_);
    end

    % The next two lines look after the special case at wsz == 1 which is
    % repeated and this upsets interp1()
    indx = find(abs(diff(wsz) < eps));
    wsz(indx + 1) = wsz(indx + 1) + 2*eps;

    a2(i_) = interp1(wsz,As,w2(i_));
    a1(i_) = interp1(wsz,As,w1(i_));
    h(i_) = (a2(i_) - a1(i_))/(w2(i_) - w1(i_));
    if isnan(h)
        keyboard;
    end
end
