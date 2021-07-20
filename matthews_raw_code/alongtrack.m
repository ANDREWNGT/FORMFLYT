function f = alongtrack(R,N,d1,d2)

    arguments
        R
        N
        d1
        d2
    end
    
    G=6.67408e-20 % because R is in kilometres!!
    %m3.kg-1.s-2 to km3.kg-1.s-2

    M=5.97219e24
    fac=G*M
    
    %understand why we must keep track from the perspective of the
    %satellite A that is lagging and that has to descend into the ellipse!!
    
    %this is to ensure that the catchup point is at the apogee. the ppoint
    %at which it starts catching up and finishes catching up.
    
    %this means the PERSPECTIVE of ONE PERIOD must be read from this
    %satellite.
    
    delta=(d1-d2)/R %phase difference to be caught up in radians
    %satellite A descends into elliptical orbit
    %in one period of satellite A, satellite B, which is still in circular
    %orbit, covers coverage=2*pi-delta/N
    coverage=2*pi-delta/N
    
    %period of original orbit
    T0 = 2*pi*sqrt((R^3)/fac)
    Tnew=T0*coverage/(2*pi)
    new_a=((fac/(4*pi^2))*(Tnew^2))^(1/3)
    %current radius becomes apogee of new semimajor axis which has to be
    %smaller.
    new_e=R/new_a-1
    new_v=sqrt(fac*((2/R)-(1/new_a)))
    delta_v=sqrt(fac/R)-new_v
    
    fprintf("Lagging satellite A descends to an elliptical orbit. \n")
    fprintf("This ellipse has semimajor axis - %f km and eccentricity %f. \n", new_a, new_e)
    fprintf("Satellite A fires retrograde thrust with delta_v %f m/s. \n", 1000*delta_v)
    fprintf("After %d orbits, Satellite A catches up. \n", N)
    fprintf("Satellite A then fires prograde thrust with delta_v %f m/s.\n", 1000*delta_v)
    fprintf("Total delta_v required for satellite A is %f m/s.\n", 2000*delta_v)
    
    
    