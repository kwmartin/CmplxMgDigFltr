function z = s2z(s,wp)
%   Z = s2z(s,wp) is used to transform a frequency s=jw in s domain
%   to a value in the transformed z domain. wp is the two pass-band frequencies
%   The transform is: z = sqrt((s - j*wp(2))./(s - j*wp(1)))
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
%   Ken Martin: 11/24/03
%   Revised: 10/20/18

z = sqrt((s - j*wp(2))./(s - j*wp(1)));