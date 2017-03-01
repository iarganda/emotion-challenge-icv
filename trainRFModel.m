%TRAINRFMODEL trains a random forest classifier.
% [Mdl] = trainRFModel( DATA, FEATURENAME, TARGETNAME, NUMTREES ) returns a
% random forest model of NUMTREES trees train in all samples provided in
% DATA using as feature FEATURENAME, as target TARGETNAME.
%
% Example:
%         [Mdl] = trainRFModel( faces, 'dex_chalearn_features_fc7', 'label', 100 );
%
% Author: Ignacio Arganda-Carreras (ignacio.arganda@ehu.eus)
% License: GPL-3.
function [Mdl] = trainRFModel( data, featureName, targetName, numTrees )

X = zeros( length( data ), length( data{1}.( featureName ) ) );
Y = cell( length( data ), 1 );


for i = 1:length( data )
    X(i,:) = data{ i }.( featureName );       
    Y{i} = data{ i }.( targetName );
end

Y = categorical( Y );
tic
Mdl = TreeBagger(numTrees, X, Y,'OOBPrediction','On',...
    'Method','classification');
toc