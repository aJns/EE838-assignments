function similarity = calc_similarity(feature1, feature2) 

diff = feature1 - feature2;
ssd = sum(diff(:).^2);

similarity = ssd;

