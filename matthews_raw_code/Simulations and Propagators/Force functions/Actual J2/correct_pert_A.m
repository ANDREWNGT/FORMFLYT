function f=correct_pert_A(p)
    arguments
        p
    end
    
    f=invsq(p)+correct_oblateness(p);