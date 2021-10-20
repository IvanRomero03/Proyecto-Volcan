% Inicializar el area de riesgo
%y^2 + x^2 = 20000^2;
Color = [0.8500 0.3250 0.0980];
Radio = 20000;
ang=0:0.01:2*pi; 
xp=Radio.*cos(ang);
yp=Radio.*sin(ang);
patch(xp,yp,Color)
hold on


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
    axis([-15000 15000 -15000 15000 0 10000])
    view([50 30 90])
    grid on
    colormap(hot)

%inicializar nuestros valores
V0 = randi([300, 500],1); %velocidad inicial m/s
alpha = deg2rad(randi([0, 360],1)); %angulo alpha
beta = deg2rad(randi([30, 150],1)); %angulo beta
gama = deg2rad(randi([0, 360],1)); %angulo gama
x0 = 0; %psoicion inicial x
y0 = 5452; %posicion inicial y (altura de popocatepetl)
z0 = 0; %posicion inicial z
g = 9.8; %gravedad
V0x = V0*cos(alpha); %Velocidad x
V0y = V0*cos(beta); %Velocidad y
V0z = V0*cos(gama); %Velocidad z

hold on;

%%%%%%%%%%% Euler %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determinar los parámetros iniciales para el *Método de Euler*
%%%%%%%%%%%%Checar esto%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = 0;
intervalo = 1;
%%%%%% Falta conseguir un coeficiente de fricción %%%%%%%%
b = 0.3;
masa = randi([2 15],1);
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
    x_posicion = [x_posicion; x_posicion(length(x_posicion)) + x_velocidad(length(x_velocidad))*intervalo];
    
    z_velocidad = [z_velocidad; z_velocidad(length(z_velocidad)) - (b * z_velocidad(length(z_velocidad)) / masa)*intervalo];
    z_posicion = [z_posicion; z_posicion(length(z_posicion)) + z_velocidad(length(z_velocidad))*intervalo];
    plot3(x_posicion,z_posicion,y_posicion,'->')
    pause(0.1)
    hold on
end


%%%%%%%%%%%%%%%%%%% Método analítico %%%%%%%%%%%%%%%%%%%%%%%
% Modelación con el método analítico

syms y_2(tiempo) x_2(tiempo) z_2(tiempo) vel 

m = masa;

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

ti = 0;
t = intervalo;

DeltaT = 0:intervalo:t;
ySyms = feval(ySol,DeltaT);
xSyms = feval(xSol, DeltaT);
zSyms = feval(zSol, DeltaT);
y = double(ySyms);
x = double(xSyms);
z = double(zSyms);

plot3(x,z,y,'-o')

while y(length(y)) > 0
    t = t + intervalo;
    DeltaT = (t - intervalo):intervalo:t;
    ySyms = feval(ySol,DeltaT);
    xSyms = feval(xSol, DeltaT);
    zSyms = feval(zSol, DeltaT);
    y = [y;double(ySyms)];
    x = [x;double(xSyms)];
    z = [z;double(zSyms)];
    plot3(x,z,y,'-o')
    pause(0.1)
    hold on
end

%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Marcar área de impacto %%%%%%%%%%%%%%%%%%%%%%%
% Tomar las coordenadas de impacto y hacer un circulo con el área de
% peligro en ese impacto
%%%% OPCIONAL 
% Hacer un archivo que guarde las muestras 

x_c = x_posicion(length(x_posicion))- 200;
z_c = z_posicion(length(z_posicion))- 200;
pos = [x_c z_c 400 400]; 
rectangle('Position',pos,'Curvature',[1 1],'EdgeColor','b', 'LineWidth',3)
M2 = [ 0 x_posicion(length(x_posicion)) z_posicion(length(z_posicion))];
%T = array2table(M2,'VariableNames',{'y','x','z'})
%[nombre, direccion] = uiputfile({'*.txt','Posiciones de Impacto'},'Guardar Como')
%writetable(T, [direccion,nombre],' | ' )
fName = 'Muestras.txt';
fid = fopen(fName,'a');            % abrir archivo
fprintf(fid, '%f %f %f \n',M2);

fclose(fid);

%%%%%%%%%% Surf de área de riesgo %%%%%%%%%%%%%%%%%%%%%
% Determinar un caso "máximo" (Con parámetros máximos)
%Dados esos parámtros, determinar una matriz de área del caso
% Listo


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
