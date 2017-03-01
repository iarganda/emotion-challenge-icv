%APPLYMODELFUSION apply a learned model to the given data trained using the
% fusion of features.
% [Y] = APPLYMODELFUSION( MDL, DATA, FEATURENAME1, FEATURENAME2 ) returns
% the predicted labels of MODEL applied to the samples included in DATA
% (which is a cellarray created using for example CREATEVALIDATIONMAT)
% using the fusion of the features defined by FEATURENAME1 and
% FEATURENAME2.
%
% Example:
%         [Y] = applyModelFusion( Mdl, faces, 'dex_chalearn_features_fc6', 'dex_chalearn_features_fc7' );  
%
% Author: Ignacio Arganda-Carreras (ignacio.arganda@ehu.eus)
% License: GPL-3.
function [Y] = applyModelFusion( Mdl, data, featureName1, featureName2 )

X = zeros( length( data ), length( data{1}.( featureName1 )) + length( data{1}.( featureName2 )) );


for i = 1:length( data )
    X(i,:) = vertcat(data{ i }.( featureName1 ), data{ i }.( featureName2 ));
end

Y = predict( Mdl, X );