% Top level for designing a 15'th order complex digital bandpass filter
% (same complexity as 30'th order real filter), with 12
% movable poles, one fixed pole at dc, and 2 fixed poles at -1. The
% passband is at postive frequencies only between 0.05 and 0.1 Hz.

p = 2*pi*[-0.35 -0.3 -0.25 -0.2 -0.15 -0.125 -0.1 -0.075 -0.05 -0.02 0.16 0.18 0.25 0.35]; % initial guess at moveable finite loss poles
px = [0.0]; % fixed pole
ni=2; % number of loss poles at infinity
wpHz = [0.05 0.1];
wpRd = 2*pi*wpHz;
wp = 2*tan(wpRd./2.0); % predistort passband (wpRd is desired final passband in Rad.)
ws = 2*pi*[-0.0 0.15]; % lower and upper stopband frequencies
ws = 2*pi*[-0.0 0.15]; % lower and upper stopband frequencies
as = [20 20];
Ap = 0.05; % the passband ripple in dB
type = 'elliptic'


H = design_dig_filt(p,px,ni,wp,ws,as,Ap,type);
plot_drsps(H, wpHz, 'b', [-400 10]); % Note non-distorted passband is in Hz
cscdFltr = mkCscdFltrD2(H, wp);
plotSimCscd(cscdFltr, wpHz, ws, -300, 0, 'b');
runMcCscd(cscdFltr, wpHz, 1e-5, 0, 100, [-300, 10], 'b');
drawnow;
cscdHndl = gcf;
print('../examples/Figures/dig_fltr_2_14_1/dig_fltr_2_14_1','-dpdf');
print('../examples/Figures/dig_fltr_2_14_1/dig_fltr_2_14_1','-dpng');
toc

a=1;