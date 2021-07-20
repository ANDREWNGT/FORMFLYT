function f = Separation_RAAN_change(g)
    arguments
        g
    end
    
    %takes in a function that gives the same parameters input by RAAN
    %as well as other required parameters
    %in the format [R,oi,of,i,Lold,Lnew]
   
    R=g(1)
    oi=g(2)
    of=g(3)
    i=g(4)
    Lold=g(5)
    Lnew=g(6)
    
    %calcultate position vector of position of burn;delta_v inn PQW frame
    theta=linspace(0,2*pi,1000)
    x=R*cos(theta)
    y=R*sin(theta)
    %here we use radians so we DONT have to LOOP thru so many values
    
    RT11i= cosd(oi)*cosd(Lold)-sind(oi)*cosd(i)*sind(Lold) %use geree function here as ARGUMENTS IN DEGREES!!
    RT21i= sind(oi)*cosd(Lold)+cosd(oi)*cosd(i)*sind(Lold)
    RT31i= sind(i)*sind(Lold)
    RT12i=-cosd(oi)*sind(Lold)-sind(oi)*cosd(i)*cosd(Lold)
    RT22i=-sind(oi)*sind(Lold)+cosd(oi)*cosd(i)*cosd(Lold)
    RT32i=sind(i)*cosd(Lold)
    
       
    %fake argument of perigee
    RT11f= cosd(of)*cosd(Lnew)-sind(of)*cosd(i)*sind(Lnew) %use geree function here as ARGUMENTS IN DEGREES!!
    RT21f= sind(of)*cosd(Lnew)+cosd(of)*cosd(i)*sind(Lnew)
    RT31f= sind(i)*sind(Lnew)
    RT12f=-cosd(of)*sind(Lnew)-sind(of)*cosd(i)*cosd(Lnew)
    RT22f=-sind(of)*sind(Lnew)+cosd(of)*cosd(i)*cosd(Lnew)
    RT32f=sind(i)*cosd(Lnew)
    
    
    Xchief=x.*RT11i+y.*RT12i % array here, remember to use element-wise operator
    Ychief=x.*RT21i+y.*RT22i
    Zchief=x.*RT31i+y.*RT32i
    
    Xdep=x.*RT11f+y.*RT12f % array here, remember to use element-wise operator
    Ydep=x.*RT21f+y.*RT22f
    Zdep=x.*RT31f+y.*RT32f
    
    Separation_vec = zeros(1000,3)
    for i =1:1000
        Separation_vec(i,:)=[Xdep(i)-Xchief(i),Ydep(i)-Ychief(i),Zdep(i)-Zchief(i)]
    end
    
    Separation_mag = zeros(1000,1)
    for i=1:1000
        Separation_mag(i) =  norm(Separation_vec(i,:))
    end
    
    fprintf("Position (km,ECI) at closest approach:[%f,%f,%f]\n", Xchief(1),Ychief(1),Zchief(1))
    fprintf("Closest approach: %f km\n", Separation_mag(1))
    fprintf("Greatest separation:%f km\n", max(Separation_mag))
    
    
  
    