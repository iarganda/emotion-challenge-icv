facesLoaded = exist( 'faces', 'var' );
if facesLoaded == 0
    load( 'training.mat' );
end

caffe.set_mode_gpu();
gpu_id = 0;  % we will use the first gpu in this demo
caffe.set_device(gpu_id);

chalearn = 1;

% Initialize the network using dex-imdb-wiki model.
if chalearn
    model_dir = '/home/iarganda/workspace/caffe/models/dex_chalearn/';
else
    model_dir = '/home/iarganda/workspace/caffe/models/dex_imdb_wiki/';
end

net_model = [model_dir 'age.prototxt'];

if chalearn
    net_weights = [model_dir 'dex_chalearn_iccv2015.caffemodel'];
else
    net_weights = [model_dir 'dex_imdb_wiki.caffemodel'];
end

phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Please download IDMB_WIKI from its site before you run this demo');
end

% Initialize a network
net = caffe.Net(net_model, net_weights, phase);

% caffe/matlab/+caffe/imagenet/ilsvrc_2012_mean.mat contains mean_data that
% is already in W x H x C with BGR channels
d = load('/home/iarganda/workspace/caffe/matlab/+caffe/imagenet/ilsvrc_2012_mean.mat');
mean_data = d.mean_data;
CROPPED_DIM = 224;
mean_data_resized = imresize(mean_data,[CROPPED_DIM CROPPED_DIM], 'bilinear');

numFiles = length( faces );

tic;
for K = 1 : numFiles
    filename = [ faces{K}.path faces{K}.filename ];
    
    im = imread( filename );
    
    if size( im,  3) == 1
        im = cat( 3, im, im, im );
    end

    % Convert an image returned by Matlab's imread to im_data in caffe's data
    % format: W x H x C with BGR channels
    im_data = im(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
    im_data = permute(im_data, [2, 1, 3]);  % flip width and height
    im_data = single(im_data);  % convert from uint8 to single


    im_data = imresize(im_data, [CROPPED_DIM CROPPED_DIM], 'bilinear');  % resize im_data
    im_data = im_data - mean_data_resized;  % subtract mean_data (already in W x H x C, BGR)
    crops_data=im_data;

    input_data = { crops_data };

    % The net forward function. It takes in a cell array of N-D arrays
    % (where N == 4 here) containing data of input blob(s) and outputs a cell
    % array containing data from output blob(s)
    scores = net.forward(input_data);

    fc7 = net.blobs('fc7').get_data();
    fc6 = net.blobs('fc6').get_data();
    
    if chalearn
        faces{ K }.dex_chalearn_features_fc7 = fc7;
        faces{ K }.dex_chalearn_features_fc6 = fc6;
    else    
        faces{ K }.imdb_wiki_features_fc7 = fc7;
        faces{ K }.imdb_wiki_features_fc6 = fc6;
    end
    
end
toc;

% call caffe.reset_all() to reset caffe
caffe.reset_all();

save( 'training.mat', 'faces', '-v7.3' );