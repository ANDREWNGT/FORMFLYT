function [final, start_time] =maneuver_processing(list, dt)
%%%Function to output quantity associated with each distinct manuever over
%%%time.
%%%Also outputs start time of the maneuvers. 
    c      = cumsum(list);
    index  = strfind([list,0] ~= 0, [true, false]);
    final = [c(index(1)), diff(c(index))];
    start_time = index.*dt;
end