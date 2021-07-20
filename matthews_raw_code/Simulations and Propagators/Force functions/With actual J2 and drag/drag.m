function d = drag(Atden,v, A, D, M)
    arguments 
        Atden %atmospheric density kgm^-3
        v %velocity vector km/s
        A %cross sectional area m^2
        D %drag coefficient 
        M %mass, kg
    end
    
    %Atden is the function that already takes in the altitude of the
    %satellite and returns the atmospheric density in terms of kgm^-3
    
    Atden=Atden*10e9; % to km^-3
    A=A*10e-6; %to km^2
    %takes in v as a vector
    v_mag= norm(v);
    %magnitude of drag force here
    dmag=(1/2)*Atden*(v_mag^2)*A*D/M;
    
    d=-(dmag/v_mag).*v;
    
    
    %gives the drag as an acceleration vector opposing direction of motion
    
    
    
    