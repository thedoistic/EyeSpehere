function [y, x, r] = findpeaks3d(H, threshold)

    % To finding local maxima above threshold
    max_filtered = imregionalmax(H);
    [y, x, r] = ind2sub(size(H), find(max_filtered & H >= threshold));
end