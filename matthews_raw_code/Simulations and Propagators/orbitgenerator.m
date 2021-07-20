%this function GENERATES a full orbit with orbital elements as input:
%a - semimajor axis
%e - eccentricity
%o - RAAN
%i - inclination angle
%w - argument of perigee
function f = orbitgenerator(a,e,o,i,w)
    arguments
        a
        e
        o
        i
        w
        
    end
    %FOLLOW THE order of transformation matrix for RAAN, incln,
    %arg_of_perigee
    
    p=a*(1-e^2)
    theta=linspace(0,2*pi, 10000)
    r=p./(1+e*cos(theta)) %radians!
    x=r.*cos(theta) % again array, use element-wise operator
    y=r.*sin(theta)
    
    
    RT11= cosd(o)*cosd(w)-sind(o)*cosd(i)*sind(w) %use geree function here as ARGUMENTS IN DEGREES!!
    RT21= sind(o)*cosd(w)+cosd(o)*cosd(i)*sind(w)
    RT31= sind(i)*sind(w)
    RT12=-cosd(o)*sind(w)-sind(o)*cosd(i)*cosd(w)
    RT22=-sind(o)*sind(w)+cosd(o)*cosd(i)*cosd(w)
    RT32=sind(i)*cosd(w)
    X=x.*RT11+y.*RT12 % array here, remember to use element-wise operator
    Y=x.*RT21+y.*RT22
    Z=x.*RT31+y.*RT32
    
    plot3(X,Y,Z,'LineWidth',1.5, 'Color','r')
    hold on
    Ellipsoid_generator(6378.1370,6378.1370,6356.7523) %WG84, dim in kilometres!
    xlabel('x')
    ylabel('y')
    zlabel('z')
    daspect([1,1,1])
    grid on
    
    title('Orbit generated in ECI')
    
end


    
    
  