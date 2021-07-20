function f = Ellipsoid_generator(a,b,c)
    arguments
        a
        b
        c
    end
    phi = linspace(0,2*pi,90)
    theta = linspace(-pi,pi,45)
    [P,T]=meshgrid(phi, theta)
    X=a.*sin(T).*cos(P)
    Y=b.*sin(T).*sin(P)
    Z=c.*cos(T)
    f=surf(X,Y,Z)
    daspect([1,1,1])
    
end
