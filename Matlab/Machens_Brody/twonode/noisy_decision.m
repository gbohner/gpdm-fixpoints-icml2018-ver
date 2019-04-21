%mfmaster - reproduce Fig. S???
%
%   mfmaster simulates the mean-field two-node model
%   doing the two-interval discrimination for a fixed
%   set of stimulus combinations (f1,f2).
%   [ (f1,f2) = (1,2) (2,1) (2,3) (3,2) ... (6,7( (7,6) ]
%   The simulation parameters and i/o function are taken
%   from the function 'initpar.m'.

%   (c) 2004 CK Machens & CD Brody

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function noisy_decision;

initpar;
% par.mfnoise = 0.5; % Change this in initpar, mfsim calls it again

%--------------(f1,f2) combinations
ftrial = [4,4];
% ftrial =  [ 1,2; 2,3; 3,4; 4,5; 5,6; 6,7; ...
% 	    2,1; 3,2; 4,3; 5,4; 6,5; 7,6 ];
% ftrial = [1,1; 2,2; 3,3; 4,4; 5,5; 6,6; 7,7];

%--------------plot defaults
figure(2); clf;
set(gcf,'MenuBar','none');
rcs = rainbow_colors(length(par.gE_loadpm));
nocolor   = 0.85*[206 185 118]/255;
yescolor  = 0.98*[119 187 206]/255;
hold on;

%--------------loop over (f1,f2) combination
Ntrials = 30;
trial_types = size( ftrial,1 );
%
% Store all the trajectories in the format we expect them for our python
% code:
y_python = [];

for l=1:Ntrials
  f1 = ftrial(mod(l, trial_types)+trial_types*(mod(l, trial_types)==0),1);
  f2 = ftrial(mod(l, trial_types)+trial_types*(mod(l, trial_types)==0),2);
%   f1 = 4;
%   f2 = 4;
  fprintf ('testing [f1,f2]=[%d,%d]\n',f1,f2);
  [trajx, trajy, t] = mfsim( f1, f2, 0, 0); 
  
  y_python(1,:,l) = trajy;
  y_python(2,:,l) = trajx;
  
%   %plot this trace  
%   pp = plot( t(t<par.TSO2+200),  1000*trajx(t<par.TSO2+200) );
%   set( pp, 'Color', rcs(f1,:) );
%   pp = plot( t(t>=par.TSO2+200), 1000*trajx(t>=par.TSO2+200) );
%   if ( f1>f2 )
%     set( pp, 'Color', yescolor );
%   else
%     set( pp, 'Color', nocolor );
%   end
  plot(trajy(1:5:end), trajx(1:5:end))
  drawnow;

end

save(['MachensBrodySim_' datestr(now,30) '.mat'], 'y_python', 'par')

% %--------------finish plots
% xlabel('time (msec)');
% ylabel('ns (output)');
% axis( [0 par.T 0 4] );
