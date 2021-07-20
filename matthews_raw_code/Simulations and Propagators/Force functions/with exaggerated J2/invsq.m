%function to be propagated, acceleration as a function of position due
%to Newton's Law

function result = invsq(p) %argument is a 1x3 vector
    arguments
       p 
    end
    G=6.67408e-20 % because R is in kilometres!!
    %m3.kg-1.s-2 to km3.kg-1.s-2

    M=5.97219e24
    fac=G*M
    denom=(norm(p))^3
    result = [-fac*p(1)/denom,-fac*p(2)/denom,-fac*p(3)/denom]
    

end

    
    