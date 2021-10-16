%inicializar nuestra cónica
hold on

r = linspace(0.03*pi,pi) ;
    th = linspace(0,2*pi) ;
    [R,T] = meshgrid(r,th) ;
    X = 2500*R.*cos(T) ;
    Y = 2500*R.*sin(T) ;
    Z = -R*5000;
    Z = Z+5700;
    surf(X,Y,Z)
    axis([-6000 6000 -6000 6000 0 7000])
    colormap(hot)

%inicializar nuestros valores
V0 = randi([83, 139],1); %velocidad inicial m/s
alpha = randi([0, 360],1); %angulo alpha
beta = randi([30, 150],1); %angulo beta
gama = randi([0, 360],1); %angulo gama
x0 = 0; %psoicion inicial x
y0 = 5492; %posicion inicial y (altura de popocatepetl)
z0 = 0; %posicion inicial z
g = 9.8; %gravedad
V0x = V0*cos(alpha); %Velocidad x
V0y = V0*cos(beta); %Velocidad y
V0z = V0*cos(gama); %Velocidad z

hold on;

%%%%%%%%%%% Euler %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determinar los parámetros iniciales para el *Método de Euler*
t = 0;
intervalo = 1;
b = 0.5;
masa = 80;
pendiente = 0;

%Para y (altura)
y_velocidad = V0y;
y_aceleracion = g;
y_posicion = y0;

%Para x
x_velocidad = V0x;
x_posicion = x0;


%Para z
z_velocidad = V0z;
z_posicion = z0;

plot3(x_posicion,z_posicion,y_posicion,'->')
    %establecer las iteraciones por medio del método de euler

while y_posicion(length(y_posicion)) > 0
    t = t + intervalo;
    pendiente = -(b * y_velocidad(length(y_velocidad)) / masa) - y_aceleracion;
    y_velocidad = [y_velocidad; y_velocidad(length(y_velocidad)) + pendiente * intervalo];
    y_posicion = [y_posicion; y_posicion(length(y_posicion)) + y_velocidad(length(y_velocidad))*intervalo];
    
    x_velocidad = [x_velocidad; x_velocidad(length(x_velocidad)) - (b * x_velocidad(length(x_velocidad)) / masa)*intervalo];
    x_posicion = [x_posicion; x_posicion(length(x_posicion)) - x_velocidad(length(x_velocidad))*intervalo];
    
    z_velocidad = [z_velocidad; z_velocidad(length(z_velocidad)) - (b * z_velocidad(length(z_velocidad)) / masa)*intervalo];
    z_posicion = [z_posicion; z_posicion(length(z_posicion)) - z_velocidad(length(z_velocidad))*intervalo];
    plot3(x_posicion,z_posicion,y_posicion,'->')
    pause(0.1)
    hold on
end

%%%%%%%%%%%%%%%%%%%%%% FALTA CORREGIR LA GRAFICACIÓN %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Método analítico %%%%%%%%%%%%%%%%%%%%%%%
% Modelación con el método analítico

syms y_2(tiempo) x_2(tiempo) z_2(tiempo) vel b m

vel = diff(y_2,tiempo);

% posición y
eqn_y = diff(y_2,tiempo,2) == -g - b*(vel)/m;
cond_y = [y_2(0)==y0, vel(0)==V0y];
ySol(tiempo) = dsolve(eqn_y,cond_y);

vel = diff(x_2,tiempo);

% posición x
eqn_x = diff(x_2,tiempo,2) == -b*(vel)/m;
cond_x = [x_2(0)==x0, vel(0)==V0x];
xSol(tiempo) = dsolve(eqn_x,cond_x);

vel = diff(z_2,tiempo);

% posición z
eqn_z = diff(z_2,tiempo,2) == -b*(vel)/m;
cond_z = [z_2(0)==z0, vel(0)==V0z];
zSol(tiempo) = dsolve(eqn_z,cond_z);

t = 0;
tiempoFinal = 10;

fplot3(zSol,xSol,ySol,[tiempo tiempoFinal], '-o')

while y(length(y)) > 0
    tiempo = tiempo + intervalo;
    y = [y;double(ySol(tiempo))];
    x = [x;double(xSol(tiempo))];
    z = [z;double(zSol(tiempo))];
    plot3(x,z,y,'-o')
    pause(0.1)
    hold on
end

%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Surf de área de riesgo %%%%%%%%%%%%%%%%%%%%%
% Determinar un caso "máximo" (Con parámetros máximos)
%Dados esos parámtros, determinar una matriz de área del caso

%%% Extra %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Experimentar con un posible %%%%%%%%%%%%%%%%%%%% 
% poblado, dentro de la zona de riesgo %%%%%%%%%%%%%%%
% Determinar un área pequeña del tamaño de un posible
% En riesgo

%%%Simulación del tiro parabólico sin fricción%%%%%%%%%%
%comenzar con las iteraciones y graficación simultanea
%{
while y > 0
    t = t + 1;
    x = [x; x0 + V0x*t];
    y = [y; y0 + V0y*t - (1/2)*g*t.^2];
    z = [z; z0 + V0z*t];
    plot3(x,z,y,'-o')
    pause(0.1)
    hold on
end
%}

hold off
