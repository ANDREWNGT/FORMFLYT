%obtains the orbit through numerical integration of Newton's law of
%gravitation and J2 perturbation potential without the KNOWN SOLUTION EXPRESSION

%takes in initial orbtial elements which undergo perturbation with time

function f=RK4orbitsolver(a, e, o, i, w) %in terms of initial orbit elements, start plot from PERIGEE
    arguments
        a
        e
        o
        i
        w
    end
    %FOLLOW THE order of transformation matrix for RAAN, incln,
    %arg_of_perigee
    G=6.67408e-20 % because R is in kilometres!!
    %m3.kg-1.s-2 to km3.kg-1.s-2

    M=5.97219e24
    fac=G*M
    
    RT11= cosd(o)*cosd(w)-sind(o)*cosd(i)*sind(w) %use geree function here as ARGUMENTS IN DEGREES!!
    RT21= sind(o)*cosd(w)+cosd(o)*cosd(i)*sind(w)
    RT31= sind(i)*sind(w)
    RT12=-cosd(o)*sind(w)-sind(o)*cosd(i)*cosd(w)
    RT22=-sind(o)*sind(w)+cosd(o)*cosd(i)*cosd(w)
    RT32=sind(i)*cosd(w)
    
    %at perigee, the satellite only has x coordinate with magnitude of
    %perigee, let this be intial conditions
    x0=a*(1-e)
    %mean angular rate
    n=sqrt(fac/(a^3))
    
    
    
    X0=x0*RT11 % not array here, no element-wise operator
    Y0=x0*RT21
    Z0=x0*RT31
    
    %velocity at perigee
    v0=a*n*sqrt((1+e)/(1-e))
    VX0=v0*RT12 
    VY0=v0*RT22
    VZ0=v0*RT32
    
    N=500
    Position=zeros(N,3)
    Velocity=zeros(N,3)
    Position(1,:)=[X0,Y0,Z0]
    Velocity(1,:)=[VX0,VY0,VZ0]
    dt=20 % 15 seconds
    %total 10000s orbit
    
        
    
    for i = 1:N % remember indexing 1 to N in matlab array!!
                
        % dx/dt = f(x,y,z,vx,vy,vz,t)=vx and so on
        % dvx/dt = g(x,y,z,vx,vy,vz,t)=g(x,y,z)and so on
        
        kp1= Velocity(i,:)
        kv1= invsq(Position(i,:))
        
        %NOTICE how the 'ki's from each position and veclotcity must be
        %paired in this order IN ORDER TO BE USED by the next pair!!
        
        kp2= Velocity(i,:)+(dt/2).*kv1 %an array of three
        kv2= invsq(Position(i,:)+(dt/2).*kp1)
        
        kp3= Velocity(i,:)+(dt/2).*kv2
        kv3= invsq(Position(i,:)+(dt/2).*kp2)
        
        kp4= Velocity(i,:)+dt.*kv3
        kv4= invsq(Position(i,:)+dt.*kp3)
        
                     
        Position(i+1,:) = Position(i,:)+(dt/6).*(kp1+2.*kp2+2.*kp3+kp4)
        Velocity(i+1,:) = Velocity(i,:)+(dt/6).*(kv1+2.*kv2+2.*kv3+kv4) 
              
        
    end
    
    plot3(Position(:,1),Position(:,2),Position(:,3), 'LineWidth',1, 'Color', 'r')
    hold on
    Ellipsoid_generator(6378.1370,6378.1370,6356.7523) %WG84, dim in kilometres!
    xlabel('x')
    ylabel('y')
    zlabel('z')
    daspect([1,1,1])
    grid on
    
    title('Orbit with J2 solved by RK4 in ECI')
    
end