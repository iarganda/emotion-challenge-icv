%
% Example:
%         [Mdl] = trainSVMfusion( faces, 'dex_chalearn_features_fc6', 'dex_chalearn_features_fc7', 'label' );
%
function [Mdl] = trainSVMFusion( data, featureName1, featureName2, targetName )

X = zeros( length( data ), length( data{1}.( featureName1 ) ) +  length( data{1}.( featureName2 ) ));
Y = cell( length( data ), 1 );

%if isnumeric( data{1}.(targetName) )  
    for i = 1:length( data )
        X(i,:) = vertcat(data{ i }.( featureName1 ), data{ i }.( featureName2 ));
        Y{i} = data{ i }.( targetName );
    end
%else
%    for i = 1:length( data )
%        X(i,:) = data{ i }.( featureName );       
%        Y(i) = str2double( data{ i }.( targetName ) );        
%    end
%end

Y = categorical( Y );
tic
%options = statset('UseParallel',1);
%t = templateSVM( 'KernelFunction','gaussian' );
%Mdl = fitcecoc(X,Y, 'Coding','onevsall', 'Learners', t, 'Prior','uniform', 'Options', options );
Mdl = fitcecoc( X, Y, 'Coding','onevsall' );
toc

