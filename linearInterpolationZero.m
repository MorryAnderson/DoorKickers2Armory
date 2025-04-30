function value = linearInterpolationZero(start_x, end_x, start_y, end_y, x)
    if (x <= start_x && x > 0)
        value = 0;
    elseif (x > end_x)
        value = 0;
    else
        value = start_y + (x - start_x)*(end_y - start_y)/(end_x - start_x);
    end
end