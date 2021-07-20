%this function also takes in the same inputs as orbitgenerator.m but it
%obtains the orbit through numerical integration of Newton's law of
%gravitation, without the KNOWN SOLUTION EXPRESSION

%this is esential as a transition to the next solver which will involve
%more complex force laws and the orbital elements DO NOT stay constant
%anymore, and a SOLUTION EXPRESSION CANNOT be directly obtained

function f=orbitsolver(a, e, o, i, w) %in terms of initial orbit elements, start plot from PERIGEE
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
    
    N=4500
    Position=zeros(N,3)
    Velocity=zeros(N,3)
    Position(1,:)=[X0,Y0,Z0]
    Velocity(1,:)=[VX0,VY0,VZ0]
    dt=2 %2 seconds
    A=-fac.*invsq([X0,Y0,Z0]) %reminder elementwise, REMEMBER NEGATIVE SIGN!!
    
    for i = 1:N % remember indexing 1 to N in matlab array!!
        Position(i+1,:) = Position(i,:)+Velocity(i,:).*dt %update velocity %reminder elementwise
        Velocity(i+1,:) = Velocity(i,:)+A.*dt %reminder elementwise
        A=-fac.*invsq(Position(i+1,:)) %PHYSICS LAW HERE, of current position CENTRAL FORCE, 
        %update for next loop, so take in i+1 for POSITION!! basically of
        %the NEW POSITION just calculated in previous loop
        
    end
    
    plot3(Position(:,1),Position(:,2),Position(:,3), 'LineWidth',1, 'Color', 'r')
    hold on
    Ellipsoid_generator(6378.1370,6378.1370,6356.7523) %WG84, dim in kilometres!
    xlabel('x')
    ylabel('y')
    zlabel('z')
    daspect([1,1,1])
    grid on
    
    title('Orbit solved in ECI')
    
end


    
    
    
    
    