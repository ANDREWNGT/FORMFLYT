function f=pert_A(p)
    arguments
        p
    end
    
    f=invsq(p)+oblateness(p)