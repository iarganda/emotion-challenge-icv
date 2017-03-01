%% TRAINING
load( 'training.mat' );

% train SVM to learn main emotion
Mdl1 = trainSVMFusion( faces, 'dex_chalearn_features_fc6', 'dex_chalearn_features_fc7', 'label2' );
Mdl2 = cell(7,1);

for kk=1:7
    kk
    % create subset with second emotion
    n = 1;
    for jj=1:length( faces )
        %if( strcmp( faces{jj}.label1, num2str( kk ) ) )
        if( strcmp( faces{jj}.label2, num2str( kk ) ) )
            faces2{n} = faces{jj};
            n = n+1;
        end
    end
    Mdl2{ kk } = trainSVMFusion( faces2, 'dex_chalearn_features_fc6', 'dex_chalearn_features_fc7', 'label1' );
end

%% VALIDATION
load( 'validation.mat' );

% apply all models
Y1 = applyModelFusion( Mdl1, facesVal, 'dex_chalearn_features_fc6', 'dex_chalearn_features_fc7' );
Y2 = cell(7,1);
for kk=1:7
   Y2{kk} = applyModelFusion( Mdl2{ kk }, facesVal, 'dex_chalearn_features_fc6', 'dex_chalearn_features_fc7' );
end

for kk=1:length( facesVal )
    if Y1(kk) == 'N' 
        Y{kk} = 'N_N';
    else
       Y{ kk } = [char( Y2{ grp2idx( Y1(kk) )}(kk) ) '_' char( Y1( kk ))];
    end    
end

fileID = fopen('predictions.txt','w');
for kk = 1:length( Y )
    fprintf(fileID, '%s\n', Y{kk});
end
fclose( fileID );
