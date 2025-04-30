function value = linearInterpolationHold(start_x, end_x, start_y, end_y, x)
    if (x <= start_x)
        value = start_y;
    elseif (x > end_x)
        value = end_y;
    else
        value = start_y + (x - start_x)*(end_y - start_y)/(end_x - start_x);
    end
end