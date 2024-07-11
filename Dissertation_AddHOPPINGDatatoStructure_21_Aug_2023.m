%% SECTION 1 - Load Data Structure
load( 'Post-Quals Data/Data Structure/Current Version/David_DissertationDataStructure_17_Apr_2024.mat');



CreateStruct.Interpreter = 'tex';
CreateStruct.Resize = 'on';
CreateStruct.WindowStyle = 'modal';


lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 1',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




%% SECTION 2 - Find Pathways for V3D Output
path_file = uigetfile('*.xlsx','MultiSelect','on');
% path_file = path_file';
    %Find desired signal file
path_directory=uigetdir();
    %Find directory that houses desired signal file

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




%% SECTION 3 - Load Hopping V3D Output as Tables - Control Group, Without MSLVJ

lasterror = [];

%Path directory is the pathway to the general folder. Path file is the name of the file itself,
%including the file extension.
% HoppingGRFandKin_StaticTrial = readtable([path_directory '/' path_file{ 7 }],"ReadVariableNames",true);



%CODE BELOW IS FOR CONTROL GROUP

%Load V3D data for LEFT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb

HoppingGRFandKin_PreferredHz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 4 } ],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_LLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_LLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_LLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_5 = [];



HoppingGRFandKin_2Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{1}],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_LLimb_Trial1.COFP = HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_LLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_LLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_5 = [];



HoppingGRFandKin_2Point33Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 2 }],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_LLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_5 = [];





%Load V3D data for RIGHT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb
HoppingGRFandKin_PreferredHz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_RLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_RLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_RLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_5 = [];



HoppingGRFandKin_2Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_RLimb_Trial1.COFP = HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_RLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_RLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_5 = [];



HoppingGRFandKin_2Point33Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 5 } ],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_RLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_5 = [];




if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end



%% SECTION 3 - Load Hopping V3D Output as Tables - Control Group, With MSLVJ

%FOR PARTICIPANTS WITH MSLVJ
%Load V3D data for LEFT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb
HoppingGRFandKin_2Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_LLimb_Trial1.COFP = HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_LLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_LLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_LLimb_Trial1.FP3_5 = [];



HoppingGRFandKin_2Point33Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 2 }],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_LLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_LLimb_Trial1.FP3_5 = [];




HoppingGRFandKin_PreferredHz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 3 } ],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_LLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_LLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_LLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_LLimb_Trial1.FP3_5 = [];
 


MSLVJ_LLimb_AllTrials = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true);

MSLVJ_LLimb_AllTrials.COFP = MSLVJ_LLimb_AllTrials.FP3_3;
MSLVJ_LLimb_AllTrials.COFP_1 = MSLVJ_LLimb_AllTrials.FP3_4;
MSLVJ_LLimb_AllTrials.COFP_2 = MSLVJ_LLimb_AllTrials.FP3_5;

MSLVJ_LLimb_AllTrials.FP3_3 = [];
MSLVJ_LLimb_AllTrials.FP3_4 = [];
MSLVJ_LLimb_AllTrials.FP3_5 = [];




%Load V3D data for RIGHT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb
HoppingGRFandKin_2Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_RLimb_Trial1.COFP = HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_RLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_RLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_RLimb_Trial1.FP3_5 = [];



HoppingGRFandKin_2Point33Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 6 } ],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_RLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_RLimb_Trial1.FP3_5 = [];




HoppingGRFandKin_PreferredHz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 7 }],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_RLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_RLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_RLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_RLimb_Trial1.FP3_5 = [];




MSLVJ_RLimb_AllTrials = readtable([path_directory '/' path_file{ 8 }],"ReadVariableNames",true);

MSLVJ_RLimb_AllTrials.COFP = MSLVJ_RLimb_AllTrials.FP3_3;
MSLVJ_RLimb_AllTrials.COFP_1 = MSLVJ_RLimb_AllTrials.FP3_4;
MSLVJ_RLimb_AllTrials.COFP_2 = MSLVJ_RLimb_AllTrials.FP3_5;

MSLVJ_RLimb_AllTrials.FP3_3 = [];
MSLVJ_RLimb_AllTrials.FP3_4 = [];
MSLVJ_RLimb_AllTrials.FP3_5 = [];




% MSLVJ_RLimb_Trial1 = readtable([path_directory '/' path_file{ 8 }],"ReadVariableNames",true);
% 
% MSLVJ_RLimb_Trial1.COFP = MSLVJ_RLimb_Trial1.FP3_3;
% MSLVJ_RLimb_Trial1.COFP_1 = MSLVJ_RLimb_Trial1.FP3_4;
% MSLVJ_RLimb_Trial1.COFP_2 = MSLVJ_RLimb_Trial1.FP3_5;
% 
% MSLVJ_RLimb_Trial1.FP3_3 = [];
% MSLVJ_RLimb_Trial1.FP3_4 = [];
% MSLVJ_RLimb_Trial1.FP3_5 = [];
% 
% 
% 
% 
% MSLVJ_RLimb_Trial2 = readtable([path_directory '/' path_file{ 9 }],"ReadVariableNames",true);
% 
% MSLVJ_RLimb_Trial2.COFP = MSLVJ_RLimb_Trial2.FP3_3;
% MSLVJ_RLimb_Trial2.COFP_1 = MSLVJ_RLimb_Trial2.FP3_4;
% MSLVJ_RLimb_Trial2.COFP_2 = MSLVJ_RLimb_Trial2.FP3_5;
% 
% MSLVJ_RLimb_Trial2.FP3_3 = [];
% MSLVJ_RLimb_Trial2.FP3_4 = [];
% MSLVJ_RLimb_Trial2.FP3_5 = [];




if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end







%% SECTION 3 - Load Hopping V3D Output as Tables - ATx Group, Without MSLVJ


%Load V3D data for LEFT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 3 }],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_5 = [];






HoppingGRFandKin_2Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_5 = [];






HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 2 } ],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_5 = [];







%Load V3D data for RIGHT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_5 = [];



HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_5 = [];




HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_5 = [];




if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




%% SECTION 3 - Load Hopping V3D Output as Tables - ATx Group, With MSLVJ


% FOR PARTICIPANTS WITH MSLVJ
%Load V3D data for LEFT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_InvolvedLimb_Trial1.FP3_5 = [];




HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 2 } ],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1.FP3_5 = [];




HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 3 } ],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1.FP3_5 = [];






MSLVJ_InvolvedLimb_AllTrials = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true);

MSLVJ_InvolvedLimb_AllTrials.COFP = MSLVJ_InvolvedLimb_AllTrials.FP3_3;
MSLVJ_InvolvedLimb_AllTrials.COFP_1 = MSLVJ_InvolvedLimb_AllTrials.FP3_4;
MSLVJ_InvolvedLimb_AllTrials.COFP_2 = MSLVJ_InvolvedLimb_AllTrials.FP3_5;

MSLVJ_InvolvedLimb_AllTrials.FP3_3 = [];
MSLVJ_InvolvedLimb_AllTrials.FP3_4 = [];
MSLVJ_InvolvedLimb_AllTrials.FP3_5 = [];






%Load V3D data for RIGHT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true);

HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1.FP3_5 = [];




HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true);

HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.COFP = HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1.FP3_5 = [];





HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 7 }],"ReadVariableNames",true);

HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.COFP = HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_3;
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.COFP_1 = HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_4;
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.COFP_2 = HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_5;

HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_3 = [];
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_4 = [];
HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1.FP3_5 = [];




MSLVJ_NonInvolvedLimb_AllTrials = readtable([path_directory '/' path_file{ 8 }],"ReadVariableNames",true);

MSLVJ_NonInvolvedLimb_AllTrials.COFP = MSLVJ_NonInvolvedLimb_AllTrials.FP3_3;
MSLVJ_NonInvolvedLimb_AllTrials.COFP_1 = MSLVJ_NonInvolvedLimb_AllTrials.FP3_4;
MSLVJ_NonInvolvedLimb_AllTrials.COFP_2 = MSLVJ_NonInvolvedLimb_AllTrials.FP3_5;

MSLVJ_NonInvolvedLimb_AllTrials.FP3_3 = [];
MSLVJ_NonInvolvedLimb_AllTrials.FP3_4 = [];
MSLVJ_NonInvolvedLimb_AllTrials.FP3_5 = [];




if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end







%% SECTION 4 - Save Hopping V3D Output in Data Structure - Control Group, Without MSLVJ
%Add the data for the new participant into the data structure. Setfield allows creation of new data
%structure fields or the addition of data to an existing structure field. Here, the hopping
%kinematics and kinetics are being given a new field within the appropriate limb.

lasterror = [];

%For the CONTROL Group, we'll save data under Left vs. Right Limbs

% %Save CoM Position for Static Trial - store in data structure
% % David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals', 'Control' , 'HC30', 'HoppingKinematicsKinetics', 'StaticTrial', HoppingGRFandKin_StaticTrial );


%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for left limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC12','HoppingKinematicsKinetics','LeftLimb', 'PreferredHz','Trial1',HoppingGRFandKin_PreferredHz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC12','HoppingKinematicsKinetics','LeftLimb', 'TwoHz','Trial1',HoppingGRFandKin_2Hz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC12','HoppingKinematicsKinetics','LeftLimb', 'TwoPoint3Hz','Trial1',...
    HoppingGRFandKin_2Point33Hz_LLimb_Trial1);



%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for left limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC12','HoppingKinematicsKinetics','RightLimb', 'PreferredHz','Trial1',HoppingGRFandKin_PreferredHz_RLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC12','HoppingKinematicsKinetics','RightLimb', 'TwoHz','Trial1',HoppingGRFandKin_2Hz_RLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC12','HoppingKinematicsKinetics','RightLimb', 'TwoPoint3Hz','Trial1',HoppingGRFandKin_2Point33Hz_RLimb_Trial1);



clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end






%% SECTION 4 - Save Hopping V3D Output in Data Structure - Control Group, With MSLVJ


%FOR PARTICIPANTS WITH MSLVJ
%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for left limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingKinematicsKinetics','LeftLimb', 'PreferredHz','Trial1',...
    HoppingGRFandKin_PreferredHz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingKinematicsKinetics','LeftLimb', 'TwoHz','Trial1',...
    HoppingGRFandKin_2Hz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingKinematicsKinetics','LeftLimb', 'TwoPoint3Hz','Trial1',...
    HoppingGRFandKin_2Point33Hz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJKinematicsKinetics','LeftLimb', 'AllTrials', MSLVJ_LLimb_AllTrials);



%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for left limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingKinematicsKinetics','RightLimb', 'PreferredHz','Trial1',...
    HoppingGRFandKin_PreferredHz_RLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingKinematicsKinetics','RightLimb', 'TwoHz','Trial1',...
    HoppingGRFandKin_2Hz_RLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingKinematicsKinetics','RightLimb', 'TwoPoint3Hz','Trial1',...
    HoppingGRFandKin_2Point33Hz_RLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJKinematicsKinetics','RightLimb', 'AllTrials', MSLVJ_RLimb_AllTrials);

% 
% David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJKinematicsKinetics','RightLimb', 'Trial1', MSLVJ_RLimb_Trial1);
% 
% David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJKinematicsKinetics','RightLimb', 'Trial2', MSLVJ_RLimb_Trial2);



clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end







%% SECTION 4 - Save Hopping V3D Output in Data Structure - ATx Group, Without MSLVJ

%For the ATx GROUP, we'll save data under Involved vs NonInvolved Limbs

%Save CoM Position for Static Trial - store in data structure
% David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals', 'ATx' , 'ATx18', 'HoppingKinematicsKinetics', 'StaticTrial', HoppingGRFandKin_StaticTrial );

%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for Involved limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','InvolvedLimb', 'PreferredHz','Trial1',HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','InvolvedLimb', 'TwoHz','Trial1',HoppingGRFandKin_2Hz_InvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','InvolvedLimb', 'TwoPoint3Hz','Trial1',HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1);


%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for NonInvolved limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','NonInvolvedLimb', 'PreferredHz','Trial1',HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','NonInvolvedLimb', 'TwoHz','Trial1',HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','NonInvolvedLimb', 'TwoPoint3Hz','Trial1',...
    HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1);



clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end






%% SECTION 4 - Save Hopping V3D Output in Data Structure - ATx Group, With MSLVJ

%FOR PARTICIPANTS WITH MSLVJ
%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for Involved limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','InvolvedLimb', 'PreferredHz','Trial1',HoppingGRFandKin_PreferredHz_InvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','InvolvedLimb', 'TwoHz','Trial1',HoppingGRFandKin_2Hz_InvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','InvolvedLimb', 'TwoPoint3Hz','Trial1',HoppingGRFandKin_2Point33Hz_InvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','MSLVJKinematicsKinetics','InvolvedLimb', 'AllTrials', MSLVJ_InvolvedLimb_AllTrials);


%Save preferred Hz, 2.3 Hz, and 2.0 Hz hopping for NonInvolved limb - store in data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','NonInvolvedLimb', 'PreferredHz','Trial1',HoppingGRFandKin_PreferredHz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','NonInvolvedLimb', 'TwoHz','Trial1',HoppingGRFandKin_2Hz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingKinematicsKinetics','NonInvolvedLimb', 'TwoPoint3Hz','Trial1',...
    HoppingGRFandKin_2Point33Hz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','MSLVJKinematicsKinetics','NonInvolvedLimb', 'AllTrials', MSLVJ_NonInvolvedLimb_AllTrials);



clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end








%% SECTION 5 - Find Pathways for Hopping MVIC Data

lasterror = [];

%NOTE: USE STATIC0001 for HC30 - now labeled restingEMG

path_file = uigetfile('*.csv','MultiSelect','on');
    %Find desired signal file
    
%Transpose data so that all files are now stored in separate rows, making it easier to read than if
%the files were in columns
path_file = path_file';

path_directory=uigetdir();
    %Find directory that houses desired signal file



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 5',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




%% SECTION 6 - Load Hopping MVIC Data as Tables

lasterror = [];

%Load EMG data for MVICs and Resting EMG. Path directory is the pathway to the general folder. Path file is the name of the file itself,
%including the file extension. Loading as a table will preserve column names
HoppingMVIC_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial2 = readtable([path_directory '/' path_file{ 2 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial3 = readtable([path_directory '/' path_file{ 3 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial4 = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial5 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial6 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial7 = readtable([path_directory '/' path_file{ 7 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial8 = readtable([path_directory '/' path_file{ 8 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial9 = readtable([path_directory '/' path_file{ 9 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial10 = readtable([path_directory '/' path_file{ 10 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial11 = readtable([path_directory '/' path_file{ 11 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingMVIC_Trial12 = readtable([path_directory '/' path_file{ 12 }],"ReadVariableNames",true,"NumHeaderLines",13);

HoppingRestingEMG = readtable([path_directory '/' path_file{ 13 }],"ReadVariableNames",true,"NumHeaderLines",13);



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 6',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end



%% SECTION 7- Save Hopping MVIC Data in Data Structure - Control Group

%Add the data for the new participant into the data structure. Setfield allows creation of new data
%structure fields or the addition of data to an existing structure field. Here, the hopping
%kinematics and kinetics are being given a new field within the appropriate limb.

lasterror = [];

% Save MVIC and Resting EMG data for CONTROL Group

David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','RestingEMG',HoppingRestingEMG);

David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial1',HoppingMVIC_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial2',HoppingMVIC_Trial2);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial3',HoppingMVIC_Trial3);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial4',HoppingMVIC_Trial4);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial5',HoppingMVIC_Trial5);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial6',HoppingMVIC_Trial6);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial7',HoppingMVIC_Trial7);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial8',HoppingMVIC_Trial8);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial9',HoppingMVIC_Trial9);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial10',HoppingMVIC_Trial10);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial11',HoppingMVIC_Trial11);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control', 'HC30','HoppingEMG','MVIC','Trial12',HoppingMVIC_Trial12);


clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 7',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end






%% SECTION 7- Save Hopping MVIC Data in Data Structure - ATx Group

% Save MVIC and Resting EMG data for ATx Group

David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','RestingEMG',HoppingRestingEMG);

David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial1',HoppingMVIC_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial2',HoppingMVIC_Trial2);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial3',HoppingMVIC_Trial3);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial4',HoppingMVIC_Trial4);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial5',HoppingMVIC_Trial5);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial6',HoppingMVIC_Trial6);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial7',HoppingMVIC_Trial7);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial8',HoppingMVIC_Trial8);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial9',HoppingMVIC_Trial9);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial10',HoppingMVIC_Trial10);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial11',HoppingMVIC_Trial11);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx', 'ATx18','HoppingEMG','MVIC','Trial12',HoppingMVIC_Trial12);


clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 7',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end



%% SECTION 8 - Find Pathways for Hopping EMG

lasterror = [];


path_file = uigetfile('*.csv','MultiSelect','on');
    %Find desired signal file
    

%Transpose data so that all files are now stored in separate rows, making it easier to read than if
%the files were in columns
path_file = path_file';
    
    
path_directory=uigetdir();
    %Find directory that houses desired signal file

if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 8',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

%% SECTION 9 - Load Hopping EMG as Tables - Control Group, without MLSVJ


%CODE BELOW IS FOR CONTROL GROUP

% 
% %FOR PARTICIPANTS WITHOUT MSLVJ
% 
% %Load hopping EMG data for LEFT limb. Open as tables to preserve column headers. One table for
% %self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
% %including the file extension.
% HoppingEMG_PreferredHz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 3 }],"ReadVariableNames",true,"NumHeaderLines",13);
% HoppingEMG_2Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true,"NumHeaderLines",13);
% HoppingEMG_2Point33Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 2 }],"ReadVariableNames",true,"NumHeaderLines",13);
% 
% 
% % Load hopping EMG data for RIGHT limb. Open as tables to preserve column headers. One table for
% % self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
% % including the file extension.
% HoppingEMG_PreferredHz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true,"NumHeaderLines",13);
% HoppingEMG_2Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true,"NumHeaderLines",13);
% HoppingEMG_2Point33Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true,"NumHeaderLines",13);





% if isempty( lasterror )
%     
%     msgbox('\fontsize{15} NO ERRORS IN SECTION 9',CreateStruct);
%     
% else
%     
%     error = lasterror;
%     msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
%     
% end


%% SECTION 9 - Load Hopping EMG as Tables - Control Group, with MLSVJ


%FOR PARTICIPANTS WITH MSLVJ

%Load hopping EMG data for LEFT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
%including the file extension.
HoppingEMG_2Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Point33Hz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 2 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_PreferredHz_LLimb_Trial1 = readtable([path_directory '/' path_file{ 3 }],"ReadVariableNames",true,"NumHeaderLines",13);
MSLVJEMG_LLimb_AllTrials = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true,"NumHeaderLines",13);


% Load hopping EMG data for RIGHT limb. Open as tables to preserve column headers. One table for
% self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
% including the file extension.
HoppingEMG_2Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Point33Hz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_PreferredHz_RLimb_Trial1 = readtable([path_directory '/' path_file{ 7 }],"ReadVariableNames",true,"NumHeaderLines",13);
MSLVJEMG_RLimb_AllTrials = readtable([path_directory '/' path_file{ 8 }],"ReadVariableNames",true,"NumHeaderLines",13);


% MSLVJEMG_RLimb_Trial1 = readtable([path_directory '/' path_file{ 7 }],"ReadVariableNames",true,"NumHeaderLines",13);
% MSLVJEMG_RLimb_Trial2 = readtable([path_directory '/' path_file{ 8 }],"ReadVariableNames",true,"NumHeaderLines",13);




if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 9',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end







%% SECTION 9 - Load Hopping EMG as Tables - ATx Group, without MLSVJ

%CODE BELOW IS FOR ATx GROUP

%FOR PARTICIPANTS WITHOUT MSLVJ
%Load hopping EMG data for LEFT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
%including the file extension.
HoppingEMG_PreferredHz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 3 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Point33Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 2 }],"ReadVariableNames",true,"NumHeaderLines",13);


%Load hopping EMG data for RIGHTT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
%including the file extension.
HoppingEMG_PreferredHz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Point33Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true,"NumHeaderLines",13);





if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 9',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end


%% SECTION 9 - Load Hopping EMG as Tables - ATx Group, with MLSVJ

%FOR PARTICIPANTS WITH MSLVJ
%Load hopping EMG data for LEFT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
%including the file extension.
HoppingEMG_2Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 1 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Point33Hz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 2 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_PreferredHz_InvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 3 }],"ReadVariableNames",true,"NumHeaderLines",13);
MSLVJEMG_InvolvedLimb_AllTrials = readtable([path_directory '/' path_file{ 4 }],"ReadVariableNames",true,"NumHeaderLines",13);


%Load hopping EMG data for RIGHTT limb. Open as tables to preserve column headers. One table for
%self-selected/preferred Hz, one for left limb, one for right limb. Path directory is the pathway to the general folder. Path file is the name of the file itself,
%including the file extension.
HoppingEMG_2Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 5 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_2Point33Hz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 6 }],"ReadVariableNames",true,"NumHeaderLines",13);
HoppingEMG_PreferredHz_NonInvolvedLimb_Trial1 = readtable([path_directory '/' path_file{ 7 }],"ReadVariableNames",true,"NumHeaderLines",13);
MSLVJEMG_NonInvolvedLimb_AllTrials = readtable([path_directory '/' path_file{ 8 }],"ReadVariableNames",true,"NumHeaderLines",13);





if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 9',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

%% SECTION 10 - Save Hopping EMG in Data Structure - Control Group

%Add the data for the new participant into the data structure. Setfield allows creation of new data
%structure fields or the addition of data to an existing structure field. Here, the hopping
%kinematics and kinetics are being given a new field within the appropriate limb.

lasterror = [];


%Save EMG data from hopping trials in data structure for CONTROL Group

David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingEMG','LeftLimb', 'PreferredHz','Trial1',HoppingEMG_PreferredHz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingEMG','LeftLimb', 'TwoHz','Trial1',HoppingEMG_2Hz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingEMG','LeftLimb', 'TwoPoint3Hz','Trial1',HoppingEMG_2Point33Hz_LLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJEMG','LeftLimb', 'AllTrials', MSLVJEMG_LLimb_AllTrials);


David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingEMG','RightLimb', 'PreferredHz','Trial1',HoppingEMG_PreferredHz_RLimb_Trial1 );
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingEMG','RightLimb', 'TwoHz','Trial1',HoppingEMG_2Hz_RLimb_Trial1 );
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','HoppingEMG','RightLimb', 'TwoPoint3Hz','Trial1',HoppingEMG_2Point33Hz_RLimb_Trial1 );
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJEMG','RightLimb', 'AllTrials', MSLVJEMG_RLimb_AllTrials);

% David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJEMG','RightLimb', 'Trial1', MSLVJEMG_RLimb_Trial1);
% David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HC30','MSLVJEMG','RightLimb', 'Trial2', MSLVJEMG_RLimb_Trial2);

clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 10',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end





%% SECTION 10 - Save Hopping EMG in Data Structure - ATx Group


%Save EMG data from hopping trials in data structure for ATx Group
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingEMG','InvolvedLimb', 'PreferredHz','Trial1',HoppingEMG_PreferredHz_InvolvedLimb_Trial1 );
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingEMG','InvolvedLimb', 'TwoHz','Trial1',HoppingEMG_2Hz_InvolvedLimb_Trial1 );
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingEMG','InvolvedLimb', 'TwoPoint3Hz','Trial1',HoppingEMG_2Point33Hz_InvolvedLimb_Trial1 );
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','MSLVJEMG','InvolvedLimb', 'AllTrials', MSLVJEMG_InvolvedLimb_AllTrials );

David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingEMG','NonInvolvedLimb', 'PreferredHz','Trial1',HoppingEMG_PreferredHz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingEMG','NonInvolvedLimb', 'TwoHz','Trial1',HoppingEMG_2Hz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','HoppingEMG','NonInvolvedLimb', 'TwoPoint3Hz','Trial1',HoppingEMG_2Point33Hz_NonInvolvedLimb_Trial1);
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','ATx18','MSLVJEMG','NonInvolvedLimb', 'AllTrials', MSLVJEMG_NonInvolvedLimb_AllTrials );

clearvars -except David_DissertationDataStructure CreateStruct lasterror 

clc


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 10',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end


%% SECTION 11 - Update ATx VAS Log - Find Pathways

path_file = uigetfile('*.xlsx');

    %Find desired signal file
path_directory=uigetdir();
    %Find directory that houses desired signal file

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 11',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end


%% SECTION 12 - Update ATx VAS Log - Load File

ATxVASLog = readtable( [ path_directory '/' path_file ],"ReadVariableNames",true);

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 12',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

%% SECTION 13 - Update ATx VAS Log - Add to Data Structure


David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','ATx','AllParticipants','VASLog', ATxVASLog );

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 13',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end





%% SECTION 14 - Update Morphology Log - Find Pathways

path_file = uigetfile('*.xlsx');

    %Find desired signal file
path_directory=uigetdir();
    %Find directory that houses desired signal file

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 14',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end


%% SECTION 15 - Update Morphology Log - Load File

MorphologyLog = readtable( [ path_directory '/' path_file ],"ReadVariableNames",true);

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 15',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

%% SECTION 16 - Update Morphology Log - Add to Data Structure


David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','AllGroups','MorphologyLog', MorphologyLog );

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 16',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end








%% SECTION 17 - Update Mass Log - Find Pathways

path_file = uigetfile('*.xlsx');

    %Find desired signal file
path_directory=uigetdir();
    %Find directory that houses desired signal file

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 17',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end


%% SECTION 18 - Update Mass Log - Load File

MassLog = readtable( [ path_directory '/' path_file ],"ReadVariableNames",true);

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 18',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

%% SECTION 19 - Update Mass Log - Add to Data Structure


David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','AllGroups','MassLog', MassLog );

    
lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 19',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end
