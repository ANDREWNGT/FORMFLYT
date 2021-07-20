% Function to be propagated includes acceleration due to gradient of J2 term.


function result = oblateness(p)

    arguments
        p
    end
    G=6.67408e-20 % because R is in kilometres!!
    %m3.kg-1.s-2 to km3.kg-1.s-2
    M=5.97219e24
    fac=G*M
    R = 6378.137 %Planet radius, km
    J2 = 1.0826267e-3 %Planet oblateness
    
    r5 = norm(p)^5
    r2 = norm(p)^2
    tmp = (p(3)^2)/r2
    oblate_x = 15*J2*fac*((R^2)/r5)*p(1)*(5*tmp-1)
    oblate_y = 15*J2*fac*((R^2)/r5)*p(2)*(5*tmp-1)
    oblate_z = 15*J2*fac*((R^2)/r5)*p(3)*(5*tmp-3)
    
    result = [oblate_x, oblate_y, oblate_z]
    
end
