%APPLYMODEL apply a learned model to the given data.
% [Y] = APPLYMODEL( MDL, DATA, FEATURENAME ) returns the predicted labels
% of MODEL applied to the samples included in DATA (which is a cellarray
% created using for example CREATEVALIDATIONMAT) using the feature with
% name FEATURENAME.
%
% Example:
%         [Y] = applyModel( Mdl, faces, 'dex_chalearn_features_fc7' );  
%
% Author: Ignacio Arganda-Carreras (ignacio.arganda@ehu.eus)
% License: GPL-3.
function [Y] = applyModel( Mdl, data, featureName )

X = zeros( length( data ), length( data{1}.( featureName ) ) );

for i = 1:length( data )
    X(i,:) = data{ i }.( featureName );       
end

Y = predict( Mdl, X );