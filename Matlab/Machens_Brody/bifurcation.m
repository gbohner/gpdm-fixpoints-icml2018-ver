initpar_decision;


global xgrd;
global fx;
xgrd = par.x;       % i/o function: x
fx   = par.fx;      % i/o function: y=f(x)
lambda= par.lambda; % exc/inh scaling factor
w    = par.wI;      % inhibitory weight
tau  = par.Itau;    % time constant of dynamics
gn   = par.mfnoise; % additive noise
t    = 1:par.T;     % note: time step dt = 1 msec


%post-decision
%Ex( par.TSF2+1:par.T ) = par.gE_deci;  % one possibility to store
%Ey( par.TSF2+1:par.T ) = par.gE_deci;  % the decision outcome


%--------------initialize plots
figure(1); clf;
set(gcf,'MenuBar','none');
nc1 = plot( xgrd, xgrd ); hold on;
nc2 = plot( xgrd, xgrd );
posxy = plot(0,0, '.');
set( nc1, 'Color', 'k', 'EraseMode', 'xor' );
set( nc2, 'Color', 'g', 'EraseMode', 'xor' ); 
set( posxy, 'Color', 'r', 'EraseMode', 'xor' );
set( posxy, 'MarkerSize', 20 );
xlabel('nS (plus neuron)');
ylabel('nS (minus neuron)');
axis( [0 5 0 5] );



% Varying excitatory input, show fixed points

Ex = par.gE;
Ey = par.gE;


for i = -1:0.1:1
  
    set( nc1, 'XData', 1000*xgrd, ...
  'YData', 1000*w*iofunc( -xgrd + lambda*(Ey + i*0.0001) ));
    set( nc2, 'XData', 1000*w*iofunc( -xgrd + lambda*(Ex + i*0.0001)),...
  'YData', 1000*xgrd  );
    drawnow;
    pause( 0.5 ); %slows down the dynamics;
end


function y = iofunc ( x )

global xgrd;
global fx;

N     = length( xgrd );
xmax  = max( xgrd );
fxmax = max( fx );

y  = zeros( size(x) );
u1 = find( xmax <=x );
u2 = find( 0<x & x<xmax );
u3 = find( x<=0 );

if ~isempty(u1); y(u1) = fxmax; end
if ~isempty(u2);
  ind = 1+round( N * (x(u2)-xgrd(1))/ ( xgrd(end)-xgrd(1) ));
  ind( ind>N ) = N;
  y(u2) = fx( ind );
end
if ~isempty(u3); y(u3) = 0; end;

end