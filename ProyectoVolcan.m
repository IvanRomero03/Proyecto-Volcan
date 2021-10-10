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

hold on;

t = 0;
x = x0 + V0x*t;
y = y0 + V0y*t - (1/2)*g*t^2;
z = z0 + V0z*t;
plot3(x,z,y,'-o');

while y > 0
    t = t + 1;
    x = [x; x0 + V0x*t];
    y = [y; y0 + V0y*t - (1/2)*g*t.^2];
    z = [z; z0 + V0z*t];
    plot3(x,z,y,'-o')
    pause(0.1)
    hold on
end
hold off