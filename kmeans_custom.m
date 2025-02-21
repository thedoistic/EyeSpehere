function [idx, centroids] = kmeans_custom(data, K, maxIter, distanceMetric)

    %   [IDX, CENTROIDS] = KMEANS_CUSTOM(DATA, K, MAXITER, DISTANCEMETRIC)
    %
    %   Input parameters:
    %       DATA - N x D matrix where N is the number of data points and D is the number of features.
    %       K - Number of clusters.
    %       MAXITER - Maximum number of iterations.
    %       DISTANCEMETRIC - Distance metric ('sqEuclidean' is supported).

    %   Output parameters:
    %       IDX - Cluster indices for each data point.
    %       CENTROIDS - K x D matrix of centroid positions.

    if nargin < 4
        distanceMetric = 'sqEuclidean';
    end
    if nargin < 3
        maxIter = 100;
    end

    % Initializing centroids by randomly selecting K data points
    rng('shuffle'); % Used for randomness
    randIndices = randperm(size(data, 1), K);
    centroids = data(randIndices, :);
    
    for iter = 1:maxIter
        % Computing distances from data points to centroids
        switch distanceMetric
            case 'sqEuclidean'
                % Manual computation of squared Euclidean distance
                distances = zeros(size(data, 1), K);
                for i = 1:K
                    diff = data - centroids(i, :);
                    distances(:, i) = sum(diff .^ 2, 2);
                end
            otherwise
                error('Unsupported distance metric.');
        end
        
        % Assigning each data point to the nearest centroid
        [~, idx] = min(distances, [], 2);
        
        % Recomputing centroids as the mean of assigned points
        newCentroids = zeros(size(centroids));
        for k = 1:K
            assignedData = data(idx == k, :);
            if ~isempty(assignedData)
                newCentroids(k, :) = mean(assignedData, 1);
            else
                % If a centroid loses all its points, reinitialize it randomly
                newCentroids(k, :) = data(randi(size(data, 1)), :);
            end
        end
        
        % If centroids do not change than check for convergence 
        if max(max(abs(newCentroids - centroids))) < 1e-4
            break;
        end
        
        centroids = newCentroids;
    end
end
