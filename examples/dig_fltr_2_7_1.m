% Top level for designing a 10'th order complex digital bandpass filter with 7
% movable poles, one fixed pole at dc, and 2 fixed poles at -1. The
% passband is at positive frequencies only between 0.05 and 0.1 Hz with 0.05dB ripple

p = 2*pi*[-0.35 -0.3 -0.25 -0.2 -0.15 -0.12 -0.1 0.25 0.35]; % initial guess at moveable finite loss poles
px = [0.0]; % a fixed pole at dc
ni=2; % number of loss poles at infinity
wpHz = [0.05 0.1]; % the passband in Hz
wpRd = 2*pi*wpHz; % the passband in Rad.
wp = 2*tan(wpRd./2.0); % predistort passband (wpRd is desired final passband in Rad.)
ws = 2*pi*[0.0 0.15]; % lower and upper stopband frequencies
as = [20 20];
Ap = 0.05; % the passband ripple in dB
type = 'elliptic'

% Note that wp has been predistorted
H = design_dig_filt(p,px,ni,wp,ws,as,Ap,type);
plot_drsps(H, wpHz, 'b', [-240 1]); % Note non-distorted passband is in Hz
cscdFltr = mkCscdFltrD(H, wp);
plotSimCscd(cscdFltr, wpHz, ws, -240, 0, 'b');
tic
runMcCscd(cscdFltr, wpHz, 1e-6, 0, 100, [-240, 10], 'b');
toc
drawnow;
cscdHndl = gcf;
print('../examples/Figures/dig_fltr_2_7_1','-dpdf');
print('../examples/Figures/dig_fltr_2_7_1/dig_fltr_2_7_1_mc','-dpng');
