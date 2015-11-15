function [bp,wp,dp] = whaledist(h,s,v)  
    wp = 1;
    bp = 0;
    dp = 0;
    if v > 0.0 & v < 0.66
        wp = 0;
    end
    if v > 0.8
        bp = 1;
    end
    if v > 0.7
        wp = 0;
    end
    if s > 0.3
        wp = 0;
    end
end