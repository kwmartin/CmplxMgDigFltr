function [f, ym, ya] = plotRspnsd(xin, ylim);
%   plot magnitude response xin assuming xin is from digital filter
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

n=size(xin, 1);
y=fft(xin);
ya=abs(y);
ymax = max(ya);
ym=ya./ymax;
ndB=20*log10(ym+eps);
dB=20*log10(ya+eps);
f=-0.5:1/n:0.5-1/n;

plot(f,[dB((n/2 + 1):n); dB(1:n/2)],'LineWidth',2);
axis([-0.5 0.5 ylim]);
title('Magnitude Gain')
ylabel('dB')
xlabel('Frequency')

y=y(:);
ya=ya(:);
ym=ym(:);
dB=dB(:);
f=f(:);
