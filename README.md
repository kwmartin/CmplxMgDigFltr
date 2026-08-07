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

UPDATE: Jan./2026 Another tidy up

UPDATE: Jan./2020 doing a cleanup with only routines required for magnitude response. Routine names have changed to get rid of version numbers at end

UPDATE: Dec./2018 This toolbox has undergone a major revision which is on-going. Many many bugs
in the filter approximation routines have been fixed and at the time of up-load almost all of
the examples in ./examples are working. Numerical conditioning has been significantly improved
(this is ongoing). A large number of filter realization functions have been added to ./lib. Again, the update is ongoing and not yet finished. For example, many of the library routines have been deprecated and should be deleted and/or renamed. The intention is this will occur in the next few months. Also, much of the code requires a lot of cleaning, refractoring, more documentation, etc. Again, it is hoped this will occur, and given that currently work on the toolbox is only being done by myself, part-time, it might take a bit of time. The following of this README has not been changed since 2016, but will be updated soon. Good luck, and I hope you enjoy doing complex filter design; it is an area I personally find fascinating even though it doesn't seem to be currently popular. I'm hoping that after finishing the update, I can change directions to looking into using the toolbox in some applications; one area I'm very interested in is maximally decimated filter-banks using IIR digital filters. I've played around in this previously using FIR filters, but I don't think much has been done wrt to IIR filters, and I'm hoping the toolox might be of some use for this application. The examples now include some first efforts at digital filter banks based on cascade filters (for example, see: examples/FltrBnk_1_6_0.m.
-Ken

To see some examples of designing filters, start Matlab (Copyright, 1984-2026, The Mathworks Inc.),
change directory into ./examples, add ../lib to your path using
>>path('../lib',path)
and then either run the individual exmpl?.m files

The programs in ./lib are intended for designing transfer functions for complex filters, both analog and digital.
The filters can have a single passband, and upper and lower stopbands that need not be symetrical.
The programs are highly based on the approach of Martin Snelgrove (see his unpublished paper in ./doc).
The programs and approach are described in greater detail in my 12 year old paper also in ./doc (unfortunately,
not well proofed; this is on my to-do list).
The programs were originally written in 2004, with a couple of bug fixes recently (mostly a fix for Matlab not
well supporting complex models and an extension to handle two fixed adjacent poles). It appears to me
(in 2026) that the equivalent routines have not become available in the intervening, so the
routines are being made publically available under the GPLv3 license. The routines could have bugs, and when
found, if you could e-mail me at martin@granitesemi.com, I will fix them as soon as possible. Sending suggestions and/or code to fix the
bugs will speed up the process. The programs do seem to be highly accurate for most of
the design examples.

Some suggestions for extensions (perhaps for interested graduate students looking for a thesis topic) are:
1) extend to allow for multiple passbands (perhaps using N-path filters? Franks, L. E. , and I. W. Sandberg,
"An Alternative Approach to the Realization of Network Transfer Function: The N-Path Filter. Journal,
September 1960. The Bell System Technical)

2) Extend so digital filters are designed directly without using the bilinear transform. I'm hoping to some
day get to this using an LDI like approach where the design is done using zp = z^(1/2) - z^(-1/2) as the
frequency variable, and then at the end transforming back to the normal z^(-1) variable; maybe you could beat
me to it?

3) Extend so phase equalization is included.

4) Fix the Matlab (Copyright, 1984-2026, The Mathworks Inc.) model toolboxes to properly handle complex coefficients.

5) Extend to the muliple-in multiple-out case (this would be really interesting but could be difficult).

6) Extend to adaptive filters where the poles are automatically moved to reject interferers while the exact
design of the passbands are preserved; I don't think this would be too difficult for say one or two poles,
and could be real useful for wireless front ends. Basically having the filter approximations routines running
in the background during actual system operation could take advantage of cheap (Beaglebone Black or Raspberry Pi or ESP32?) computers.

-Kenneth Martin, originally 2004, then 2016, then 2018, then 2026.
