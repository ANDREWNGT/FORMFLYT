% this function takes in a CIRCULAR ORBIT with its parameters and the
% desired initial and final RAAN, then returns the delta-V interms of a
% vector

function f = RAANchange(R,oi,of,i)
    arguments
        R
        oi
        of
        i
        
    end
    
    %realise that in a circular orbit, the argument of perigee w is
    %irrelevant!!
    
    G=6.67408e-20 % because R is in kilometres!!
    %m3.kg-1.s-2 to km3.kg-1.s-2

    M=5.97219e24
    fac=G*M
    
    v=R*sqrt(fac/(R^3))
    
    RT11i= cosd(oi) %use geree function here as ARGUMENTS IN DEGREES!!
    RT21i= sind(oi)
   
    RT12i=-sind(oi)*cosd(i)
    RT22i=cosd(oi)*cosd(i)
    RT32i=sind(i)
    
    %BECAUSE this code IS ONLY USED for circular orbits, argument of
    %pergiee is irrelevant and the true anomaly is measured from the RAAN
    %point.
    
    RT11f= cosd(of) %use geree function here as ARGUMENTS IN DEGREES!!
    RT21f= sind(of)
   
    RT12f=-sind(of)*cosd(i)
    RT22f=cosd(of)*cosd(i)
    RT32f=sind(i)
    
    theta=linspace(0,360, 100000) %degrees
   
      
   
    %initial and final VELOCITY MAGNITUDE IS SAME;
    v=R*sqrt(fac/(R^3))
    
    % Equation 3.8 from Spherical Trigonometry by Rob Johnson
    result=(cosd(i))^2+((sind(i))^2)*cosd(of-oi) %degrees
    rotate_plane=acosd(result)
    delta_v=2*v*sind(rotate_plane/2)
    % magnitude
    
    %the following lines are for obtaining direction of velocity change
    %(choosing upwards option)
    
    %spherical sine rule
    Lnew= asind(sind(i)*(sind(of-oi))/sind(rotate_plane))%this one must be the acute solution
    Lold= 180-Lnew%this one is the obtuse solution
    arg_of_lat=asind(sind(Lnew)*sind(i)) %spherical sine rule, DEGREES!
    arg_of_long=of-oi+atand(tand(Lnew)*cosd(i))
    
    
    vxi=-v.*sind(Lold) % again array, use element-wise operator
    vyi=v.*cosd(Lold)
    %becos its circular orbit, by right,the true anomaly theta doesnt need to start
    %from perigee.
    
    
    vXi=vxi.*RT11i+vyi.*RT12i % array here, remember to use element-wise operator
    vYi=vxi.*RT21i+vyi.*RT22i
    vZi=vyi.*RT32i
    
    vxf=-v.*sind(Lnew) % again array, use element-wise operator
    vyf=v.*cosd(Lnew)
    %becos its circular orbit, by right,the true anomaly theta doesnt need to start
    %from perigee.
    
    
    vXf=vxf.*RT11f+vyf.*RT12f % array here, remember to use element-wise operator
    vYf=vxf.*RT21f+vyf.*RT22f
    vZf=vyf.*RT32f
    
    delta_v_vector=[vXf-vXi,vYf-vYi,vZf-vZi]
    confirm_delta_v_mag=norm(delta_v_vector)
    
    
    
    fprintf("Rotate orbit plane upwards by %f degrees at %f degrees East,%f degrees North.\n", ...
        rotate_plane, arg_of_long,arg_of_lat)
    fprintf("magnitude of delta_v: %f m/s \n",delta_v*1000) %convert to m/s
    
    fprintf("Velocity change vector (m/s): [%f,%f,%f]\n", ...
        1000*delta_v_vector(1),1000*delta_v_vector(2),1000*delta_v_vector(3))
    fprintf("Taking the magnitude of the above, we again get: %f", 1000*confirm_delta_v_mag)
    
    f=[R,oi,of,i,Lold,Lnew]
   
   
    
    
    
    
    
    %velocity change must occur at the INTERSECTION POINT of the new plane
    %with the old plane (actually choice of this doesnt depend on ECCENTRICITY)
    
    %this code is limited to circular because for an ellipse, r is ALWAYS
    %CHANGING, cant apply spherical traingles the same way.