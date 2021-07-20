function f=full_A(p,v)
    arguments
        p
        v
    end
    alt=norm(p)-6378;
    f=invsq(p)+correct_oblateness(p)+drag(AtmosDensity(alt),v,0.374,2.2,17.9);