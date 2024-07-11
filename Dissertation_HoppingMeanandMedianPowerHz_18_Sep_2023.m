%% SECTION 1 - Load Data Structure

%Load data structure
load( 'Post-Quals Data/Data Structure/Current Version/David_DissertationDataStructure_17_Apr_2024.mat');


%Need to create a data structure for use in creating a dialog box stating there are no errors in
%this section, if all code was run
CreateStruct.Interpreter = 'tex';
CreateStruct.Resize = 'on';
CreateStruct.WindowStyle = 'modal';

%Want to clear the errors for the new section
lasterror = [];



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 1',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

%% SECTION 2 - Create Field Variables

%Want to clear the errors for the new section
lasterror = [];

%First field within data structure = data from after having completed quals
QualvsPostQualData =  {'Post_Quals'};
%Second field = group list
GroupList = {'ATx', 'Control'}; 
%Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36', 'ATx49', 'ATx39', 'ATx74' };
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34' };
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC08', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45', 'HC53', 'HC44', 'HC48', 'HC65' };
%4th field = data type
DataCategories = {'HoppingEMG'};
%5th field = limb ID
EMGID = {'MVIC'};
%6th field = trial number
MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8'};
HoppingTrialNumber = {'Trial1','Trial2'};



%Create vector of participant masses
ATxParticipantMass = [ 69.90, 64.66, 107.47, 84.35, 83.07, 68.80, 84.39, 81.96, 90.30, 79.08, 79.67, 87.51, 58.12, 61.82, 90.18, 80.99, 67.28, 70.30, 71.72, 57.66 ]; 
%ATx07, ATx08, ATx10, ATx12, ATx17, ATx18, ATx19, ATx21, ATx24, ATx25, ATx27, ATx34, ATx38, ATx41, ATx44,
%ATx50, ATx36
ControlParticipantMass = [ 57.24, 83.50, 61.37, 80.99, 105.01, 61.66, 77.14, 75.66, 79.75, 68.08, 75.28, 65.44, 82.52, 50.40, 60.45, 91.25, 60.39 ];  
%HC01, HC05, HC06, HC08, HC11, HC12, HC17, HC19, HC20, HC21, HC25, HC42, HC45, 'HC53', HC44, HC48


%String for labeling y-axis of non-normalized EMG
RawHoppingUnits_string = sprintf('Voltage (%cV)', char(956));


%Specify sampling rates for GRF, EMG, kinematics/kinetics
GRFSampHz = 1500;
EMGSampHz = 1500;
MoCapSampHz = 250;


  %Set vectors containing between-limb difference in tendon thickness for each participant
    %ATx Group - %ATx07, ATx08, ATx10, ATx12, ATx17, ATx18, ATx19, ATx21, ATx24, ATx25, ATx27, ATx34,
    %ATx38, ATx41, ATx44, ATx50, ATx36, ATx49
ATxMorphology = [ 0.75, 2.41, 1.4, 0.5, 1.57, 3.69, 2.58, 1.21, 1.94, 1.84, 2.84, 1.9, 0.43,  1.4, 3.18, 0.94, 1.09, 0.82  ];
    %Control Group - HC01, HC05, HC06, HC08, HC11, HC12, HC17, HC18, HC19, HC20, HC21, HC25
ControlMorphology = [ 0.55, 0.55, 0.35, 0.55, 0.63, 0.55, 0.55, 0.62, 0.55, 0.55, 0.55, 0.55 ];
ControlMorphology = [ 0.55, 0.55, 0.35, 0.55, 0.63, 0.55, 0.55, 0.55, 0.55, 0.55, 0.55 ];



%Set vectors containing visual analog scale rating after each hopping bout, for each participant
    %ATx Group
        %Involved Limb
            %Preferred Hz
ATxVAS_Involved_PreferredHz = [ 0, 2, 0, 0, 4, 1, 2.5, 0, 0, 0, 3, 3, 0, 0, 1.5, 0, 0, 0 ];
            %2.0 Hz
ATxVAS_Involved_TwoHz = [ 0, 1, 0, 6.5, 4, 1, 3, 0, 0, 0, 1, 1, 0, 0, 1.5, 0, 0, 0 ];
            %2.3 Hz
ATxVAS_Involved_TwoPoint3Hz = [ 0, 0, 0, 6, 3, 1, 3, 0, 0, 0, 0, 2, 0, 0, 1.5, 0, 0, 0 ];
        %Non-Involved Limb
            %Preferred Hz
ATxVAS_NonInvolved_PreferredHz = [ 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 1 ];
            %2.0 Hz
ATxVAS_NonInvolved_TwoHz = [ 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0 ];
            %2.3 hz
ATxVAS_NonInvolved_TwoPoint3Hz = [ 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0 ];
    %Control Group
ControlVAS = 0;



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end



                             


              %% SECTION 3 - Process Hopping EMG Mean and Median Power Hz
    
    

%Want to clear the errors for the new section
lasterror = [];
    
%This variable will tell the code which row of PreactivationOnsetTime_Table to fill    
RowtoFill = 1;



%Need to downsample EMG to match number of kinematic data points
NumberofElementstoAverageforDownSampling = EMGSampHz / MoCapSampHz;



    %Create a prompt so we can tell the code whether we've added any new participants
    ReprocessingDatPrompt = [ 'Are You Reprocessing Data?' ];

    %Use inputdlg function to create a dialogue box for the prompt created above.
    %First arg is prompt, 2nd is title
    ReprocessingData_Cell = inputdlg( [ '\fontsize{15}' ReprocessingDatPrompt ], 'Are You Reprocessing Data?', [1 150], {'No'} ,CreateStruct);



    %If we are NOT reprocessing data, access JointBehaviorIndex and Power_EntireContactPhase from the
    %data structure
    if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' )

        %Save the Power_EntireContactPhase table in the data structure
        PowerHz_Table  = David_DissertationDataStructure.Post_Quals.AllGroups.PowerHz_Table ;
        
        
        %RowtoFill for JointBehaviorIndex = current number of rows in JointBehaviorIndex
        RowtoFill_PowerHz_Onset2Offset_TimeSeries = size( PowerHz_Table , 1);


    %If we ARE reprocessing data, initialize JointBehaviorIndex and Power_EntireContactPhase
    else
        
    %Initialize table to hold preactivation onset times
    PowerHz_Table = NaN( 1, 13 );

    PowerFrequency_Onset2Offset_TimeSeries = NaN( 1, 11 );

    RowtoFill = 1;
        
    %Use this to tell the code which row of PowerFrequency_Onset2Offset_AllFrames to fill
    RowtoFill_PowerHz_Onset2Offset_TimeSeries = 1;
      
    end





    %If you are NOT reprocessing data, ask whether we have added any new participants
    if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' )
    
        
        %Create a prompt so we can tell the code whether we've added any new participants
        AddedNewParticipantPrompt = [ 'Have You Added A New Participant?' ];
    
        %Use inputdlg function to create a dialogue box for the prompt created above.
        %First arg is prompt, 2nd is title
        AddedNewParticipant_Cell = inputdlg( [ '\fontsize{15}' AddedNewParticipantPrompt ], 'Have You Added A New Participant?', [1 150], {'Yes'} ,CreateStruct);


    %If you ARE reprocessing data, AddedParticipantNData_Cell is set to 'No' - automatically add each
    %participant's data to table for exporting
    else

       AddedParticipantNData_Cell = {'No'};

       AddedNewParticipant_Cell = {'No'};
    
    end


            
%Create a prompt so we can manually enter the group of interest
ShowAnyPlotsPrompt = [ 'Show Any Plots ?' ];

%Use inputdlg function to create a dialogue box for the prompt created above.
%First arg is prompt, 2nd is title
ShowAnyPlots_Cell = inputdlg( [ '\fontsize{15}' ShowAnyPlotsPrompt ], 'Show Any Plots?', [1 150], {'No'} ,CreateStruct);



for l = 1 : numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});

%% Begin M For Loop - Loop Through Groups    
    
    for m = 1 : numel(GroupList)
        
        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
        ParticipantListDataStructure = getfield(GroupListDataStructure,GroupList{m} );

        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{m}, 'ATx' )
            
            ParticipantList = ATxParticipantList;
            
            ParticipantMass = ATxParticipantMass;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
            
            ParticipantMass = ControlParticipantMass;
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        
        HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
        
        
        
        
%% Begin N For Loop - Loop Through Participants        
        
        for n = 1 : numel(ParticipantList)
            
            
            %If you are NOT reprocessing data, ask whether we have added any new participants
            if strcmp( cell2mat( AddedNewParticipant_Cell ), 'Yes' ) || strcmp( cell2mat( AddedNewParticipant_Cell ), 'Y' )
            
            
                %Create a prompt so we can tell the code whether we've added any new participants
                AddParticipantNDataPrompt = [ 'Have You Added ', ParticipantList{ n }, 's Data?' ];
                
                %Use inputdlg function to create a dialogue box for the prompt created above.
                %First arg is prompt, 2nd is title
                AddedParticipantNData_Cell = inputdlg( [ '\fontsize{15}' AddParticipantNDataPrompt ], [ 'Have You Added ', ParticipantList{ n }, 's Data?' ], [1 150], {'Yes'} ,CreateStruct);
            
            
            end




            
            
            if strcmp( cell2mat( ShowAnyPlots_Cell ), 'Yes' ) || strcmp( cell2mat( ShowAnyPlots_Cell ), 'Y' )
                
                %Create a prompt so we can manually enter the group of interest
                ShowPlotsPrompt = [ 'Show Plots for  ', ParticipantList{n}, '?' ];
    
                %Use inputdlg function to create a dialogue box for the prompt created above.
                %First arg is prompt, 2nd is title
                ShowPlots_Cell = inputdlg( [ '\fontsize{15}' ShowPlotsPrompt ], 'Show Plots?', [1 150], {'No'} ,CreateStruct);

            else
                    
                ShowPlots_Cell = {'No'};

            end
            
            

%% Set Limb ID, Hopping Rate ID            
            
            %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %tables, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{n}, 'ATx07'  ) || strcmp( ParticipantList{n}, 'ATx08'  ) || strcmp( ParticipantList{n}, 'ATx10'  ) || strcmp( ParticipantList{n}, 'ATx17'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx18'  ) || strcmp( ParticipantList{n}, 'ATx21'  ) || strcmp( ParticipantList{n}, 'ATx25'  ) || strcmp( ParticipantList{n}, 'ATx36'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx38'  ) || strcmp( ParticipantList{n}, 'ATx39'  ) || strcmp( ParticipantList{n}, 'ATx41'  ) || strcmp( ParticipantList{n}, 'ATx49'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx74'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx07 has 2 hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx12'  ) || strcmp( ParticipantList{n}, 'ATx24'  ) || 
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx12 has 2 hopping rates
                HoppingRate_ID = { 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 2, 2.3 ];




            elseif strcmp( ParticipantList{n}, 'ATx19'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx07 has 2 hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 2, 2.3 ];



            elseif strcmp( ParticipantList{n}, 'ATx27'  ) || strcmp( ParticipantList{n}, 'ATx34'  ) || strcmp( ParticipantList{n}, 'ATx44'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx50'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx07 has 2 hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ]; 
                
                



            elseif strcmp( ParticipantList{ n }, 'HC11'  )
                
                %Process only the right limb of HC11
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %HC11 has only the 2.0 and 2.3 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 2, 2.3 ];
                
                



            elseif strcmp( ParticipantList{ n }, 'HC42'  )
                
                %Process only the right limb of HC11
                LimbID = { 'RightLimb', 'LeftLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %HC42 has only the 2.0 and 2.3 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{ n }, 'HC11'  ) ||  strcmp( ParticipantList{ n }, 'HC17'  ) || strcmp( ParticipantList{ n }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ n }, 'HC32'  ) || strcmp( ParticipantList{ n }, 'HC34'  ) || strcmp( ParticipantList{ n }, 'HC45'  ) || strcmp( ParticipantList{ n }, 'HC48'  )
                
                %LimbIDs for ATx participants
                LimbID = {'LeftLimb', 'RightLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx10 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];


            else
                
                %For this code, will only process the right limb
                LimbID = { 'RightLimb', 'LeftLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb',  };
                
                %HC01 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                               
            end
            
            
            
            
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ n }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ n }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
            
        
            
            
            
            %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
            ListofDataCategorieswithinParticipantN_DataStructure = getfield(ParticipantListDataStructure,ParticipantList{n});
            
            %Initalize array to hold peak MVICs - one element per muscle
             PeakMVICs = NaN(1,5);

            %Initialize table to hold power frequency time series
            PowerFrequency_Onset2Offset_TimeSeries = NaN( 1, 10 );

            %Tell the code which row of PowerFrequency_Onset2Offset_TimeSeries to fill
            RowtoFill_PowerHz_Onset2Offset_TimeSeries = 1;
            
             

             
%% BEGIN O For Loop - Loop Through Data Categories             
            for o = 1 : numel(DataCategories)
                
                %Use getfield to create a new data structure containing the list of limbs, for the EMG data.
                HoppingEMG_OriginalTable_DataStructure = getfield(ListofDataCategorieswithinParticipantN_DataStructure, 'HoppingEMG' );

                %Use getfield to create a new data structure containing the list of limbs, for the EMG data.
                HoppingEMG_IndividualHops_DataStructure = getfield(ListofDataCategorieswithinParticipantN_DataStructure, 'IndividualHops' );
                
                %Use getfield to create a new data structure containing the list of limbs, for the GRF and Kinematics data.
                HoppingGRFandKin_DataStructure = getfield(ListofDataCategorieswithinParticipantN_DataStructure, 'HoppingKinematicsKinetics');

                
                
                

%% Begin A For Loop - Loop Through Limbs                
                
                for a = 1 : numel(LimbID)
                                        
                    
%% Set Muscle IDs for Involved vs Non-Involved Limb                    
                    
                    
                    %For ATx07, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                    if strcmp( ParticipantList{n}, 'ATx07'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx07'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                         
                     %For ATx10, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx10'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx10 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        

                    %For ATx10, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx10'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx10 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         

                     %For ATx17, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx17 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                         
                     %For ATx18, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx18 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                     
                        
                        
                    
                         
                         
                     %For ATx19, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         

                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx36 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx38 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx44'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx44'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx49'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx49 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx49, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx49'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx49 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx50 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx50, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx50 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx74 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx74, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx74 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};




                    %LLGas for HC53 seems questionable. Don't include in the analysis     
                    elseif strcmp( ParticipantList{n}, 'HC53'  ) && strcmp( LimbID{ a}, 'LeftLimb')

                        %Set the muscle ID list for HC53 left limb
                        MuscleID = {'LMGas','LSol','LPL','LTA'};
                         
                         
                         
                    %For the Control group, tell the code that the MuscleID should use 'R' in front
                    %of each muscle for the Right Limb
                    elseif strcmp(LimbID{ a},'RightLimb')

                        %Set the muscle ID list for the control group right limb
                        MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                        
                     %For the Control group, tell the code that the MuscleID should use 'L' in front
                    %of each muscle for the LeftLimb
                     else

                        %Set the muscle ID list for the control group left limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                     %End the if statement for setting the muscle list   
                     end 
                    
                     

                    
                    %Use getfield to create data structure containing the EMG data for Limb A. This
                    %data structure will have the list of muscles as well as the resting EMG data
                    HoppingEMG_OriginalTable_LimbA_DataStructure = getfield(HoppingEMG_OriginalTable_DataStructure, LimbID{a} );

                    %Use getfield to create data structure containing the EMG data for Limb A. This
                    %data structure will have the list of muscles as well as the resting EMG data
                    HoppingEMG_IndividualHops_LimbA_DataStructure = getfield(HoppingEMG_IndividualHops_DataStructure, LimbID{a} );
                    
                    %Use getfield to create data structure containing the GRF and Kinematics data
                    %for Limb A.
                    HoppingGRFandKin_LimbA_DataStructure = getfield( HoppingGRFandKin_DataStructure, LimbID{a} );




                    %Use getfield to create a new data structure containing the data for indexing
                    %into various variables.
                    IndexingintoData_DataStructure = getfield( ListofDataCategorieswithinParticipantN_DataStructure, 'UseforIndexingIntoData' );

                    %Use getfield to create a new data structure containing the indexing data for
                    %Limb A
                    IndexingintoData_LimbA_DataStructure = getfield( IndexingintoData_DataStructure, LimbID{ a } );

                    
                    
                    
                    %Use getfield to create a new data structure containing the list of limbs, 
                    HoppingGRFandKin_DataStructure_IndividualHops = getfield( ListofDataCategorieswithinParticipantN_DataStructure.IndividualHops, LimbID{ a } );
                    
                    
                    
                    
                        
%% Begin Q For Loop - Loop Throuigh Muscles                        
                        
                        for q = 1 : numel( MuscleID )
                            

    %% Initialize Variables Within Q Loop
                            GContactBegin_FrameNumbers = NaN(4,numel(HoppingTrialNumber));

                            GContactEnd_FrameNumbers = NaN(4,numel(HoppingTrialNumber));

                            LengthofFlightPhase_Truncated_EMGSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            LengthofContactPhase_EMGSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            NumEl_SthHop_EMGSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            GContactBegin_EMGFrameNumbers = NaN(4,numel(HoppingTrialNumber));
                            GContactEnd_EMGFrameNumbers = NaN(4,numel(HoppingTrialNumber));

                            FirstDataPoint_SthHop_GRFSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            FirstDataPoint_SthHop_EMGSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            LastDataPoint_SthHop_MoCapSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            LastDataPoint_SthHop_EMGSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            LastDataPoint_SthHop_GRFSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            NumEl_SthHopContactPhase_MoCapSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            NumEl_SthHopContactPhase_EMGSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            NumEl_SthHopContactPhase_GRFSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            MinLengthofFlightPhase_EMGSamplingHz = NaN(4,numel(HoppingTrialNumber));



                            %Pull out the entire signal for Muscle Q
                            HoppingEMG_OriginalTable_MuscleQ_DataStructure = getfield(HoppingEMG_OriginalTable_LimbA_DataStructure, MuscleID{ q } );

                            %Pull out the individual hops for Muscle Q
                            HoppingEMG_IndividualHops_MuscleQ_DataStructure = getfield(HoppingEMG_IndividualHops_LimbA_DataStructure, MuscleID{ q } );

                            %Pull out the individual hops for the ankle
                            HoppingGRFKin_IndividualHops = getfield( HoppingEMG_IndividualHops_LimbA_DataStructure, 'Ankle' );

                            %Create prompt to ask whether to show plots for Muscle Q
                            if strcmp( cell2mat( ShowPlots_Cell  ), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell  ), 'Y' )
                
                                %Create a prompt so we can manually enter the group of interest
                                ShowMuscleQPlotsPrompt = [ 'Show Plots for  ', ParticipantList{n}, ', ' MuscleID{ q }, '?' ];
                    
                                %Use inputdlg function to create a dialogue box for the prompt created above.
                                %First arg is prompt, 2nd is title
                                ShowMuscleQPlots_Cell = inputdlg( [ '\fontsize{15}' ShowMuscleQPlotsPrompt ], [ 'Show Plots for  ', ParticipantList{n}, ', ' MuscleID{ q }, '?' ], [1 150], {'No'} ,CreateStruct);
                
                            else
                                    
                                ShowMuscleQPlots_Cell = {'No'};
                
                            end
                            
                            
 %% BEGIN B FOR LOOP - Hopping Rate ID                           
                            for b = 1 : numel(HoppingRate_ID)

                                
                                %Use get field to create a new data structure containing the EMG data for a given hopping rate. Stored under the 5th field of the structure (the list of MTUs)
                                HoppingEMG_OriginalTable_HoppingRateB_DataStructure = getfield(HoppingEMG_OriginalTable_MuscleQ_DataStructure, HoppingRate_ID{b} );

                                %Use get field to create a new data structure containing the EMG data for a given hopping rate. Stored under the 5th field of the structure (the list of MTUs)
                                HoppingEMG_IndividualHops_HoppingRateB_DataStructure = getfield(HoppingEMG_IndividualHops_MuscleQ_DataStructure, HoppingRate_ID{b} );

                                %Pull out the individual hops for the ankle contact phase angle, for a given hopping rate
                                AnkleAngle_HoppingRateB = getfield( HoppingGRFKin_IndividualHops.Sagittal.Angle, HoppingRate_ID{b} );

                                %Pull out the individual hops for the ankle contact phase torque, for a given hopping rate
                                AnkleTorque_HoppingRateB = getfield( HoppingGRFKin_IndividualHops.Sagittal.Torque, HoppingRate_ID{b} );

                                %Pull out the individual hops for the ankle contact phase power, for a given hopping rate
                                AnklePower_HoppingRateB = getfield( HoppingGRFKin_IndividualHops.Sagittal.Power, HoppingRate_ID{b} );


                                %Use getfield to create a new data structure containing the GRF and
                                %Kinematics data for a given hopping rate
                                HoppingGRFandKin_HoppingRateB_DataStructure = getfield(HoppingGRFandKin_LimbA_DataStructure, HoppingRate_ID{b} );

                                
                                %Use get field to create a new data structure containing the kinematic and kinetic data for a given hopping rate. Stored under the 5th field of the structure (the list of MTUs)
                                IndexingIntoData_HoppingRateB_DataStructure = getfield(IndexingintoData_LimbA_DataStructure, HoppingRate_ID{b} );
                                
                                
                                
                                %For now, we're only processing one trial of hopping per hopping
                                %rate
                                HoppingTrialNumber = {'Trial1'};

                             
                            
                                %Initialize variables to be used within the B loop. These will reset
                                %for each hopping rate
                                FirstDataPointofFlight_GRFData = NaN(10,numel(HoppingTrialNumber));                                
                                LastDataPointofFlight_GRFData = NaN(10,numel(HoppingTrialNumber)); 
                                FirstDataPointofFlight_EMGData = NaN(10,numel(HoppingTrialNumber));                                
                                LastDataPointofFlight_EMGData = NaN(10,numel(HoppingTrialNumber)); 
                                
                                FirstDataPointofGContact_GRFData = NaN(10,numel(HoppingTrialNumber));                                
                                LastDataPointofGContact_GRFData = NaN(10,numel(HoppingTrialNumber)); 
                                FirstDataPointofGContact_EMGData = NaN(10,numel(HoppingTrialNumber));                                
                                LastDataPointofGContact_EMGData = NaN(10,numel(HoppingTrialNumber)); 
                                
                                FirstDataPointofHop_GRFData = NaN(10,numel(HoppingTrialNumber));                                
                                LastDataPointofHop_GRFData = NaN(10,numel(HoppingTrialNumber)); 
                                FirstDataPointofHop_EMGData = NaN(10,numel(HoppingTrialNumber));                                
                                LastDataPointofHop_EMGData = NaN(10,numel(HoppingTrialNumber)); 
                                
                                
                                LengthofHop_GRFta = NaN(10,numel(HoppingTrialNumber));      
                                LengthofContactPhase_GRFData = NaN(10,numel(HoppingTrialNumber));      
                                LengthofFlightPhase_GRFData = NaN(10,numel(HoppingTrialNumber)); 
                                LengthofHop_EMGData = NaN(10,numel(HoppingTrialNumber));      
                                LengthofContactPhase_EMGData = NaN(10,numel(HoppingTrialNumber));      
                                LengthofFlightPhase_EMGData = NaN(10,numel(HoppingTrialNumber)); 
                                

                                %Create prompt to ask whether to show plots for Muscle Q
                                if strcmp( cell2mat( ShowMuscleQPlots_Cell  ), 'Yes' ) || strcmp( cell2mat( ShowMuscleQPlots_Cell  ), 'Y' )
                    
                                    %Create a prompt so we can manually enter the group of interest
                                    ShowHoppingRatePlotsPrompt = [ 'Show Plots for  ', ParticipantList{n}, ', ' MuscleID{ q }, ', ',  HoppingRate_ID{b}, '?' ] ;
                        
                                    %Use inputdlg function to create a dialogue box for the prompt created above.
                                    %First arg is prompt, 2nd is title
                                    ShowHoppingRatePlots_Cell = inputdlg( [ '\fontsize{15}' ShowHoppingRatePlotsPrompt ], [ 'Show Plots for  ', ParticipantList{n}, ', ' MuscleID{ q }, ', ',  HoppingRate_ID{b}, '?' ], [1 150], {'No'} ,CreateStruct);
                    
                                else
                                        
                                    ShowHoppingRatePlots_Cell = {'No'};
                    
                                end

                                
    %% Begin P For Loop - Once For Each Trial (Set of Hops)

                                for p = 1 : numel(HoppingTrialNumber)


                                    %% Index into Data Structure, within P Loop (Hopping Trial #)
    
                                    %Use getfield to create a new data structure containing the EMG data for
                                    %the pth hopping trial
                                    HoppingEMG_OriginalTable_TrialP = getfield(HoppingEMG_OriginalTable_HoppingRateB_DataStructure, HoppingTrialNumber{p} );
    
                                    %Use getfield to create a new data structure containing the EMG data for
                                    %the pth hopping trial
                                    HoppingEMG_IndividualHops_TrialP = getfield(HoppingEMG_IndividualHops_HoppingRateB_DataStructure,HoppingTrialNumber{p});

                                    %Pull out the individual hops for the ankle contact phase angle, for a given hopping rate
                                    AnkleAngle = getfield( AnkleAngle_HoppingRateB, HoppingTrialNumber{ p } );

                                    %Pull out the individual hops for the ankle contact phase torque, for a given hopping rate
                                    AnkleTorque = getfield( AnkleTorque_HoppingRateB, HoppingTrialNumber{ p } );

                                    %Pull out the individual hops for the ankle contact phase power, for a given hopping rate
                                    AnklePower = getfield( AnklePower_HoppingRateB, HoppingTrialNumber{ p } );

                                    %Use getfield to create a new data structure containing the GRF
                                    %and Kinematics data for the Pth hopping trial
                                    HoppingGRFandKin_TrialP_Table = getfield(HoppingGRFandKin_HoppingRateB_DataStructure, HoppingTrialNumber{p});




                                    %Pull out the rectified EMG data for
                                    %the Qth muscle in the pth hopping trial
                                    MuscleQTrialP_EntireTrial_RectifiedEMG = HoppingEMG_OriginalTable_TrialP.Rectified;

                                    %Pull out the rectified EMG data for
                                    %the Qth muscle in the pth hopping trial
                                    MuscleQTrialP_IndividualHops_RectifiedEMG = HoppingEMG_IndividualHops_TrialP.RectifiedEMG;

                                    %Pull out the normalized EMG data for
                                    %the Qth muscle in the pth hopping trial
                                    MuscleQTrialP_IndividualHops_NormalizedEMG = HoppingEMG_IndividualHops_TrialP.NormalizedEMG_NonTruncated;

                                    %Pull out the rectified EMG data for
                                    %the Qth muscle in the pth hopping trial
                                    MuscleQTrialP_IndividualHops_NonTruncated_RectifiedEMG = HoppingEMG_IndividualHops_TrialP.RectifiedEMG_NonTruncated;

                                    %Pull out the preactivation onset time for Muscle Q
                                    PreActivationOnsetTime_sec = HoppingEMG_IndividualHops_TrialP.PreactivationOnsetTime_Relative2GContactBegin_UseOnlyFlightPhas;

                                    %Convert preactivation onset time into frames
                                    PreActivationOnset_Relative2GContactBegin_Frames = HoppingEMG_IndividualHops_TrialP.PreactivationOnsetFrame_Relative2GContactBegin_UseOnlyFlightPha;

                                    %Convert preactivation onset time into frames
                                    MuscleOffset_Relative2EntireHop_Frames = HoppingEMG_IndividualHops_TrialP.MuscleOffsetFrame_Relative2EntireHop;
                                    


%% Pull out frame numbers for indexing
                                    

                                    %Pull out FirstDataPointofSthHop from the data structure. This is
                                    %the first data point for the ENTIRE hop cycle, not just flight
                                    %phase or ground contact phase alone. This was determined when
                                    %processing the GRF data - we found the minimum length of the
                                    %flight phase and subtracted this from the beginning of ground
                                    %contact phase for all hops. END RESULT is that the hops are now
                                    %synchronized to the beginning of ground contact
                                    FirstDataPoint_SthHop_EMGSampHz = IndexingIntoData_HoppingRateB_DataStructure.FirstDataPointofSthHop_Truncated_EMGSamplingHz';
    
    
                                    %Pull out the indices for the first frame of the ground contact
                                    %phase, in terms of EMG sampling Hz
                                    GContactBegin_FrameNumbers = IndexingIntoData_HoppingRateB_DataStructure.BeginGroundContact_EMGFrames;
    
                                    %Pull out the Frames for the last frame of the ground contact
                                    %phase, in terms of EMG sampling Hz
                                    GContactEnd_FrameNumbers = IndexingIntoData_HoppingRateB_DataStructure.EndGroundContact_forContactPhase_EMGFrames;
                                
                                

                                    %Pull out the frames for when braking phase ends. Note these were
                                    %found only after contact phase was segmented.
                                    BrakingPhaseEnd_Frames = IndexingIntoData_HoppingRateB_DataStructure.FrameofMinL5S1Position_EndBraking_EMGSampHz;
                                    
                                    %Pull out the frames for when propulsion phase begins. Note these were
                                    %found only after contact phase was segmented.
                                    PropulsionPhaseBegin_Frames = IndexingIntoData_HoppingRateB_DataStructure.FrameofMinL5S1Position_BeginPropulsion_EMGSampHz;



                                
                                    %Pull out the length of the flight phase, in EMG Sampling Hz
                                    LengthofFlightPhase_Truncated_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofFlightPhase_Truncated_EMGSamplingHz;

                                    %Pull out the length of the flight phase, in EMG Sampling Hz
                                    LengthofFlightPhase_NonTruncated_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofFlightPhase_NonTruncated_EMGSamplingHz;
                                    
                                    %Pull out the length of the ground contact phase, in EMG Sampling Hz
                                    LengthofContactPhase_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofContactPhase_EMGSamplingHz;
                                    
                                    %Pull out the length of the entire hop cycle, in EMG Sampling Hz
                                    LengthofEntireHopCycle_Truncated_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofEntireHopCycle_Truncated_GRFSamplingHz;
                                    
                                    %Pull out the length of the entire hop cycle, in EMG Sampling Hz
                                    LengthofEntireHopCycle_NonTruncated_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofEntireHopCycle_NonTruncated_GRFSamplingHz;
                                    
                                    %Pull out the length of the entire hop cycle, in EMG Sampling Hz
                                    LengthofEntireHopCycle_NonTruncated_MoCapSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofEntireHopCycle_NonTruncated_MoCapSamplingHz;
                                
                                
                                

                                    %Find the minimum length of the flight phase for the Qth trial of 10 hops
                                    MinLengthofFlightPhase_EMGSamplingHz = min( LengthofFlightPhase_NonTruncated_EMGSamplingHz );
    



    %% Initialize Variables within P Loop.     
    

                                    MuscleQ_Rectified_IndividualHops_Downsampled = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_IndividualHops_Downsampled = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    %Initialize variable to hold EMG data for individual hops
                                    MuscleQ_Normalized_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified4Coherence_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Highpassed4Coherence_IndividualHops_ContactPhase =  NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    NumEl_SthHop_MoCap = NaN(4,1);
                                    NumEl_SthHop_EMG = NaN(4,1);


                                    FrameNumber_MaxDifferencefromReferenceLine_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MaxDifferencefromReferenceLine_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_OnsetBeforeGContactBegin_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    FrameNumber_MaxDifferencefromReferenceLine_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MaxDifferencefromReferenceLine_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_OnsetBeforeGContactBegin_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    NumEl_SthHop_IntegratedEMG_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1); 
                                    MuscleQ_IntegratedEMG_FlightOnly = NaN(1,numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_IntegratedEMG_EntireHop = NaN(1,numel(GContactBegin_FrameNumbers(:,p)));

                                    DownsampledLength_ofHopS = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    AverageMedianPowerFrequency_FlightPhase = NaN( 1 );
                                    AverageMeanPowerFrequency_FlightPhase = NaN( 1 );
                                    AverageMedianPowerFrequency_BrakingPhase = NaN( 1 );
                                    AverageMeanPowerFrequency_BrakingPhase = NaN( 1 );
                                    AverageMedianPowerFrequency_PropulsionPhase = NaN( 1 );
                                    AverageMeanPowerFrequency_PropulsionPhase = NaN( 1 );


                                    LengthofGroundContactPhase_Onset2Offset = NaN( 1 );
                                    LengthofBrakingPhase_Onset2Offset = NaN( 1 );
                                    LengthofPropulsionPhase_Onset2Offset = NaN( 1 );
                                    LengthofEntireHop_Onset2Offset= NaN( 1 );
                                    LengthofFlightPhase_Onset2Offset= NaN( 1 );
                                        

                                    %Find the time to peak median/mean power frequency for the Flight
                                    %phase
                                    TimeToPeakMedianPowerFrequency_FlightPhase = NaN( 1 );
                                    TimeToPeakMeanPowerFrequency_FlightPhase = NaN( 1 );
                                    
                                    %Find the time to minimum median/mean power frequency for the Flight
                                    %phase
                                    TimeToMinMedianPowerFrequency_FlightPhase = NaN( 1 );
                                    TimeToMinMeanPowerFrequency_FlightPhase = NaN( 1 );
                                    
                                    %Find the median/mean power frequency at the beginning of Flight
                                    %phase
                                    MedianPowerFrequency_FirstFrameFlightPhase = NaN( 1 );
                                    MeanPowerFrequency_FirstFrameFlightPhase = NaN( 1 );

                                    %Find the median/mean power frequency at the endof Flight
                                    %phase
                                    MedianPowerFrequency_LastFrameFlightPhase = NaN( 1 );
                                    MeanPowerFrequency_LastFrameFlightPhase = NaN( 1 );

                                        
                                    %Find the time to peak median/mean power frequency for the Braking
                                    %phase
                                    TimeToPeakMedianPowerFrequency_BrakingPhase = NaN( 1 );
                                    TimeToPeakMeanPowerFrequency_BrakingPhase = NaN( 1 );
                                    
                                    %Find the time to minimum median/mean power frequency for the Braking
                                    %phase
                                    TimeToMinMedianPowerFrequency_BrakingPhase = NaN( 1 );
                                    TimeToMinMeanPowerFrequency_BrakingPhase = NaN( 1 );
                                    
                                    %Find the median/mean power frequency at the beginning of Braking
                                    %phase
                                    MedianPowerFrequency_FirstFrameBrakingPhase = NaN( 1 );
                                    MeanPowerFrequency_FirstFrameBrakingPhase = NaN( 1 );

                                    %Find the median/mean power frequency at the endof Braking
                                    %phase
                                    MedianPowerFrequency_LastFrameBrakingPhase = NaN( 1 );
                                    MeanPowerFrequency_LastFrameBrakingPhase = NaN( 1 );

                                        
                                    %Find the time to peak median/mean power frequency for the Propulsion
                                    %phase
                                    TimeToPeakMedianPowerFrequency_PropulsionPhase = NaN( 1 );
                                    TimeToPeakMeanPowerFrequency_PropulsionPhase = NaN( 1 );
                                    
                                    %Find the time to minimum median/mean power frequency for the Propulsion
                                    %phase
                                    TimeToMinMedianPowerFrequency_PropulsionPhase = NaN( 1 );
                                    TimeToMinMeanPowerFrequency_PropulsionPhase = NaN( 1 );
                                    
                                    %Find the median/mean power frequency at the beginning of Propulsion
                                    %phase
                                    MedianPowerFrequency_FirstFramePropulsionPhase = NaN( 1 );
                                    MeanPowerFrequency_FirstFramePropulsionPhase = NaN( 1 );

                                    %Find the median/mean power frequency at the endof Propulsion
                                    %phase
                                    MedianPowerFrequency_LastFramePropulsionPhase = NaN( 1 );
                                    MeanPowerFrequency_LastFramePropulsionPhase = NaN( 1 );
                                
                                    

                                    
%%  BEGIN S Loop - Each Hop

                                    for s = 1 : numel( GContactBegin_FrameNumbers(:,p) )


                                        %Find the frames for the entire hop, in EMG Samp Hz
                                        FramesforEntireHop_EMGSampHz = 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s );

                                        %Splice Hop S from the rectified EMG
                                        MuscleQTrialP_RectifiedEMG_HopS = MuscleQTrialP_IndividualHops_NonTruncated_RectifiedEMG( FramesforEntireHop_EMGSampHz, s );
                                         
                                        %Splice Hop S from the rectified EMG
                                        MuscleQTrialP_NormalizedEMG_HopS = MuscleQTrialP_IndividualHops_NormalizedEMG( FramesforEntireHop_EMGSampHz, s );


                                        %Find the frames for the entire hop, in MoCap Samp Hz
                                        FramesforEntireHop_MoCapSampHz = 1 : LengthofEntireHopCycle_NonTruncated_MoCapSamplingHz( s );

                                        %Splice Hop S from the ankle angle data
                                        AnkleAngle_HopS = AnkleAngle( FramesforEntireHop_MoCapSampHz );

                                        %Splice Hop S from the ankle torque data
                                        AnkleTorque_HopS = AnkleTorque( FramesforEntireHop_MoCapSampHz );

                                        %Splice Hop S from the ankle power data
                                        AnklePower_HopS = AnklePower( FramesforEntireHop_MoCapSampHz );

                                        %Find the frames for the flight phase, using the entire hop
                                        FlightPhase_Frames_EntireHop = 1 : LengthofFlightPhase_NonTruncated_EMGSamplingHz( s );




                                        %If the muscle turned on before or at the
                                        %beginning of flight phase, set
                                        %pre-activation onset to beginning of flight phase
                                        if PreActivationOnset_Relative2GContactBegin_Frames( s ) >= LengthofFlightPhase_NonTruncated_EMGSamplingHz( s )

                                            PreActivationOnset_Relative2GContactBegin_Frames( s ) = LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) - 1;

                                        end


                                        %Create a vector containing all Frames for Hop S's flight phase
                                        FlightPhase_Frames_Onset2Offset = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) - PreActivationOnset_Relative2GContactBegin_Frames( s ) ) : LengthofFlightPhase_NonTruncated_EMGSamplingHz( s );




                                        %If muscle de-activates during flight phase, make ground contact
                                        %phase run until the true end of ground contact. Otherwise,
                                        %ground contact ends when muscle shuts off
                                        if MuscleOffset_Relative2EntireHop_Frames( s ) <= ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 )
    
                                            %Create a vector containing all Frames for Hop S's ground contact phase
                                            GroundContactPhase_Frames_Onset2Offset = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 ) : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s );


                                             %Find the frames for the entire hop, from muscle activation to deactivation
                                             EntireHop_Frames_Onset2Offset = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) - PreActivationOnset_Relative2GContactBegin_Frames( s ) ) : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s );

                                        else

                                            %Create a vector containing all Frames for Hop S's ground contact phase
                                            GroundContactPhase_Frames_Onset2Offset = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 ) : MuscleOffset_Relative2EntireHop_Frames( s );


                                             %Find the frames for the entire hop, from muscle activation to deactivation
                                             EntireHop_Frames_Onset2Offset = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) - PreActivationOnset_Relative2GContactBegin_Frames( s ) ) : MuscleOffset_Relative2EntireHop_Frames( s );

                                        end

                                        %Splice out the time from muscle activation to deactivation, for
                                        %normalized EMG
                                        MuscleQTrialP_NormalizedEMG_Onset2Offset = MuscleQTrialP_NormalizedEMG_HopS( EntireHop_Frames_Onset2Offset  );

                                        %Find frames for entire hop, from muscle activation to
                                        %deactivation, in MoCap Sampling Hz
                                        EntireHop_Frames_Onset2Offset_MoCapSampHz = ceil( ( EntireHop_Frames_Onset2Offset ./ EMGSampHz ) .* MoCapSampHz );

                                        %Splice out the time from muscle activation to deactivation, for
                                        %ankle angle and ankle torque
                                        AnkleAngle_MuscleOnsettoOffset = AnkleAngle_HopS( EntireHop_Frames_Onset2Offset_MoCapSampHz );
                                        AnkleTorque_MuscleOnsettoOffset = AnkleTorque_HopS( EntireHop_Frames_Onset2Offset_MoCapSampHz );
                                        AnklePower_MuscleOnsettoOffset = AnklePower_HopS( EntireHop_Frames_Onset2Offset_MoCapSampHz );
                                        
                                            
                                        %Create a vector containing all Frames for Hop S's ground contact
                                        %phase, using the entire hop
                                        GroundContactPhase_Frames_EntireHop = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 ) : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s );



                                        %Find the length of Hop S's flight phase, from Onset to Offset
                                        LengthofFlightPhase_Onset2Offset( s ) = numel( FlightPhase_Frames_Onset2Offset );

                                        %Find the length of Hop S's ground contact phase, from Onset to
                                        %Offset
                                        LengthofGroundContactPhase_Onset2Offset( s ) = numel( GroundContactPhase_Frames_Onset2Offset  );

                                        %Find length of Entire Hop, from Onset 2 to Offset
                                        LengthofEntireHop_Onset2Offset( s ) = numel( EntireHop_Frames_Onset2Offset  );
                                                


                                        
                                        %Find the frames that correspond to the braking phase for Hop S
                                        BrakingPhase_HopSFrames = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 ) : ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 + round( BrakingPhaseEnd_Frames( s ) ) );

                                        %Find length of braking phase, in EMG Sampling Hz frames
                                        LengthofBrakingPhase_Onset2Offset( s ) = numel( BrakingPhase_HopSFrames );
                                        
                                            
                                        %Find the frames that correspond to the propulsion phase for Hop
                                        %S, but only until muscle shuts off
                                        PropulsionPhase_HopSFrames = ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 + round( PropulsionPhaseBegin_Frames( s ) ) ) : GroundContactPhase_Frames_Onset2Offset( LengthofGroundContactPhase_Onset2Offset( s ) );

                                        %Find length of braking phase, in EMG Sampling Hz frames
                                        LengthofPropulsionPhase_Onset2Offset( s ) = numel( PropulsionPhase_HopSFrames );

                                        %Find beginning of braking phase, relative to muscle onset
                                        BrakingPhaseBegin_Relative2Onset = numel( FlightPhase_Frames_Onset2Offset ) + 1;

                                        %Find beginning of propulsion phase, relative to muscle onset
                                        PropulsionPhaseBegin_Relative2Onset = numel( FlightPhase_Frames_Onset2Offset ) + 1 + LengthofBrakingPhase_Onset2Offset( s );



%% Plot Rectified EMG for Hop S, To Check Splitting of Hop

                                        
                                        %Only show the figure below if we told the code to show all figures
                                        %for Participant N
                                        if  strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Yes' ) || strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Y' )

                                            if s == numel( GContactBegin_FrameNumbers(:,p) )

                                                figure( 'Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Hop ' num2str( s )  ' into Flight, Braking, Propulsion Phases ', GroupList{m}, ' ', ParticipantList{n}, ' ' , LimbID{ a }, '  ', MuscleID{q}, ' ', HoppingRate_ID{b}, '  ' ,HoppingTrialNumber{p} ] )
        
                                                subplot( 4, 1, 1 )
                                                plot( FramesforEntireHop_EMGSampHz ./ EMGSampHz, MuscleQTrialP_RectifiedEMG_HopS, 'LineWidth', 2, 'Color','#0072BD' )
        
                                                L_BeginFlight = line( [ 1/1500 1/1500 ], [ 0, max( MuscleQTrialP_RectifiedEMG_HopS ) ] );
                                                L_BeginFlight.LineStyle = '-';
                                                L_BeginFlight.LineWidth = 2.5;
                                                L_BeginFlight.Color = '#7E2F8E';
        
                                                L_MuscleOnset = line( [ ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 - PreActivationOnset_Relative2GContactBegin_Frames( s ) )/1500,...
                                                    ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 - PreActivationOnset_Relative2GContactBegin_Frames( s ) )/1500 ], [ 0, max( MuscleQTrialP_RectifiedEMG_HopS ) ] );
                                                L_MuscleOnset.LineStyle = '-';
                                                L_MuscleOnset.LineWidth = 3;
                                                L_MuscleOnset.Color = 'r';
                                                
                                                L_BeginGContact = line( [ ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 ) / 1500, ( LengthofFlightPhase_NonTruncated_EMGSamplingHz( s ) + 1 ) / 1500  ], [ 0, max( MuscleQTrialP_RectifiedEMG_HopS ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ ( PropulsionPhase_HopSFrames(1) ) / 1500, ( PropulsionPhase_HopSFrames(1)  ) / 1500  ], [ 0, max( MuscleQTrialP_RectifiedEMG_HopS ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                L_MuscleOffset = line( [ ( GroundContactPhase_Frames_Onset2Offset( numel( GroundContactPhase_Frames_Onset2Offset ) ) )/1500,...
                                                   ( GroundContactPhase_Frames_Onset2Offset( numel( GroundContactPhase_Frames_Onset2Offset ) ) )/1500 ], [ 0, max( MuscleQTrialP_RectifiedEMG_HopS ) ] );
                                                L_MuscleOffset.LineStyle = '-';
                                                L_MuscleOffset.LineWidth = 3;
                                                L_MuscleOffset.Color = 'r';
                                                
                                                L_EndGContact = line( [ ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) ) / 1500, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) ) / 1500  ], [ 0, max( MuscleQTrialP_RectifiedEMG_HopS ) ] );
                                                L_EndGContact.LineStyle = '-';
                                                L_EndGContact.LineWidth = 2.5;
                                                L_EndGContact.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( MuscleQTrialP_RectifiedEMG_HopS) ] )
                                                ylabel( RawHoppingUnits_string )
                                                title('Hopping EMG Rectified')
        
                                                subplot( 4, 1, 2 )
                                                plot( FlightPhase_Frames_Onset2Offset ./ EMGSampHz, MuscleQTrialP_RectifiedEMG_HopS( FlightPhase_Frames_Onset2Offset ), 'LineWidth', 2, 'Color','#77AC30' )
                                                xlabel('Time (s)')
                                                ylim( [0 max( MuscleQTrialP_RectifiedEMG_HopS) ] )
                                                ylabel( RawHoppingUnits_string )
                                                title('Hopping EMG Rectified - Flight Phase')
        
                                                subplot( 4, 1, 3 )
                                                plot( BrakingPhase_HopSFrames ./ EMGSampHz, MuscleQTrialP_RectifiedEMG_HopS( BrakingPhase_HopSFrames ), 'LineWidth', 2, 'Color','#D95319' )
                                                xlabel('Time (s)')
                                                ylim( [0 max( MuscleQTrialP_RectifiedEMG_HopS) ] )
                                                ylabel( RawHoppingUnits_string )
                                                title('Hopping EMG Rectified - Braking Phase')
        
                                                subplot( 4, 1, 4 )
                                                plot( PropulsionPhase_HopSFrames ./ EMGSampHz, MuscleQTrialP_RectifiedEMG_HopS( PropulsionPhase_HopSFrames ), 'LineWidth', 2, 'Color', '#7E2F8E' )
                                                xlabel('Time (s)')
                                                ylim( [0 max( MuscleQTrialP_RectifiedEMG_HopS) ] )
                                                ylabel( RawHoppingUnits_string )
                                                title('Hopping EMG Rectified - Propulsion Phase')
        
        
                                                % pause
        
                                                close all

                                            end

                                        end

%                                      %Create a prompt so we can decide whether to continue script
%                                     %execution. Will only do this if the GRF time series look okay
%                                     ContinueScriptPrompt = ['Continue Script Execution?'   ParticipantList{n} '  ' LimbID{a} '  ' MuscleID{ q } '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{ p } ] ;
% 
%                                     %Use inputdlg function to create a dialogue box for the prompt created above
%                                     ContinueScript_Cell = inputdlg( [ '\fontsize{18}' ContinueScriptPrompt  ], 'Continue Script Execution? Enter No if Faulty Splitting of Hop S Into Phases', [1 150], {'Yes'} ,CreateStruct);
% 
%                                     %If there are extreme differences
%                                     if strcmp( ContinueScript_Cell{ 1 }, 'No' )
% 
%                                         return
% 
%                                     end



%% Perform STFT                                        

                                        %Set the window size for the short-time fourier transform to 500
                                        %ms
                                        WindowSize_STFT = 0.5;

                                        %Set the frequencies to be analyzed in the short-time fourier
                                        %transform
                                        Freqs = 6 : 500;
                                        
                                        %Perform STFT
                                        [Specgram, SigTime] = STFT_DTOWDissertation( MuscleQTrialP_RectifiedEMG_HopS, WindowSize_STFT, Freqs, EMGSampHz);
                                        
                                        % if s == numel( GContactBegin_FrameNumbers(:,p) )
                                        % 
                                        %     pause
                                        % 
                                        % end

                                        close all
                                        
%% Segment STFT Into Phases
                                        
                                        %Segment spectrogram into each phase of hopping
                                        Specgram_FlightPhase = Specgram( :, FlightPhase_Frames_Onset2Offset );
                                        Specgram_BrakingPhase = Specgram( :, BrakingPhase_HopSFrames );
                                        Specgram_PropulsionPhase = Specgram( :, PropulsionPhase_HopSFrames );
                                        Specgram_Onset2Offset = Specgram( :, EntireHop_Frames_Onset2Offset );
                                        
                                        
                                        %Find the amplitude for each phase of hopping
                                        Amplitude_FlightPhase = abs( Specgram_FlightPhase );
                                        Amplitude_BrakingPhase = abs( Specgram_BrakingPhase );
                                        Amplitude_PropulsionPhase = abs( Specgram_PropulsionPhase );
                                        Amplitude_Onset2Offset = abs( Specgram_Onset2Offset );
                                        
                                        %Find the power spectrum for each phase of hopping. Power =
                                        %0.5*Amplitude Squared*Sampling Hz/Frequency
                                        PowerSpectrum_EntireHop = ( 0.5.*( abs( Specgram ).^2 ) ) .*( EMGSampHz / length(Freqs ) );
                                        PowerSpectrum_FlightPhase = ( 0.5.*( ( Amplitude_FlightPhase ).^2 ) ) .*( EMGSampHz / length(Freqs ) );
                                        PowerSpectrum_BrakingPhase = ( 0.5.*( ( Amplitude_BrakingPhase ).^2 ) ) .*( EMGSampHz / length(Freqs ) );
                                        PowerSpectrum_PropulsionPhase = ( 0.5.*( ( Amplitude_PropulsionPhase ).^2 ) ) .*( EMGSampHz / length(Freqs ) );
                                        PowerSpectrum_Onset2Offset = ( 0.5.*( ( Amplitude_Onset2Offset  ).^2 ) ) .*( EMGSampHz / length(Freqs ) );
                                        
                                        %Create a time vector for each phase, in seconds, for plotting
                                        SigTime_FlightPhase = ( 1 : size(Specgram_FlightPhase,2) )./EMGSampHz;
                                        SigTime_BrakingPhase = ( 1 : size(Specgram_BrakingPhase, 2) )./EMGSampHz;
                                        SigTime_PropulsionPhase = ( 1 : size(Specgram_PropulsionPhase, 2) )./EMGSampHz;



                                        %% Plot Amplitude Spectrogram for All Phases
                                        

                                        %Only show the figure below if we told the code to show all figures
                                        %for Participant N
                                        if  strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Yes' ) || strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Y' )

                                            if s == numel( GContactBegin_FrameNumbers(:,p) )

                                                figure( 'Name', [ 'Amplitude Spectrogram', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                                subplot( 3, 1, 1 )
                                                set(gcf,'Visible','on','Position',[50 6 1304 799],'Name','Amplitude Spectrogram')
                                                imagesc(SigTime_FlightPhase, Freqs, Amplitude_FlightPhase )
                                                set( gca, 'FontSize', 16 )
                                                title( 'Amplitude Spectrogram - Flight Phase', 'FontSize', 18 )
                                                xlabel( ' Time (s) ', 'FontSize', 18 )
                                                ylabel( 'Frequencies of Interest (Hz)', 'FontSize', 18 )
                                                %Creates scaled image.
                                                %Take absolute value of spectrogram to convert complex numbers to amplitude
                                                
                                                c1 = colorbar;
                                                c1.Label.String = 'Amplitude';
                                                c1.Label.FontSize = 16;
                                                c1.Limits = [ 0, max( max( abs( Specgram ) ) ) ];
                                                %Adds color bar to plot
                                                
                                                
                                                subplot( 3, 1, 2 )
                                                set(gcf,'Visible','on','Position',[50 6 1304 799],'Name','Spectrogram')
                                                imagesc(SigTime_BrakingPhase, Freqs, Amplitude_BrakingPhase )
                                                set( gca, 'FontSize', 16 )
                                                title( 'Amplitude Spectrogram - Braking Phase', 'FontSize', 18 )
                                                xlabel( ' Time (s) ', 'FontSize', 18 )
                                                ylabel( 'Frequencies of Interest (Hz)', 'FontSize', 18 )
                                                %Creates scaled image.
                                                %Take absolute value of spectrogram to convert complex numbers to amplitude
                                                
                                                c1 = colorbar;
                                                c1.Label.String = 'Amplitude';
                                                c1.Label.FontSize = 16;
                                                c1.Limits = [ 0, max( max( abs( Specgram ) ) ) ];
                                                %Adds color bar to plot
                                                
                                                
                                                subplot( 3, 1, 3 )
                                                set(gcf,'Visible','on','Position',[50 6 1304 799],'Name','Spectrogram')
                                                imagesc(SigTime_PropulsionPhase, Freqs, Amplitude_PropulsionPhase )
                                                set( gca, 'FontSize', 16 )
                                                title( 'Amplitude Spectrogram - Propulsion Phase', 'FontSize', 18 )
                                                xlabel( ' Time (s) ', 'FontSize', 18 )
                                                ylabel( 'Frequencies of Interest (Hz)', 'FontSize', 18 )
                                                %Creates scaled image.
                                                %Take absolute value of spectrogram to convert complex numbers to amplitude
                                                
                                                c1 = colorbar;
                                                c1.Label.String = 'Amplitude';
                                                c1.Label.FontSize = 16;
                                                c1.Limits = [ 0, max( max( abs( Specgram ) ) ) ];
                                                %Adds color bar to plot
                                                
                                                % pause
                                            
    
    
                                            
                                                %% Plot Power Spectrogram for Each Phase
                                                
                                                
                                                figure( 'Name', [ 'Power Spectrogram', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                                subplot( 3, 1, 1 )
                                                set(gcf,'Visible','on','Position',[50 6 1304 799],'Name','Spectrogram - Power Spectrum')
                                                imagesc(SigTime_FlightPhase, Freqs, PowerSpectrum_FlightPhase )
                                                set( gca, 'FontSize', 16 )
                                                title( 'Power Spectrogram - Flight Phase', 'FontSize', 18 )
                                                xlabel( ' Time (s) ', 'FontSize', 18 )
                                                ylabel( 'Frequencies of Interest (Hz)', 'FontSize', 18 )
                                                %Creates scaled image.
                                                %Take absolute value of spectrogram to convert complex numbers to amplitude
                                                
                                                c1 = colorbar;
                                                c1.Label.String = 'Power';
                                                c1.Label.FontSize = 16;
                                                c1.Limits = [ 0, abs( max( max( PowerSpectrum_EntireHop ) ) ) ];
                                                %Adds color bar to plot
                                                
                                                
                                                subplot( 3, 1, 2 )
                                                set(gcf,'Visible','on','Position',[50 6 1304 799],'Name','Spectrogram')
                                                imagesc(SigTime_BrakingPhase, Freqs, PowerSpectrum_BrakingPhase )
                                                set( gca, 'FontSize', 16 )
                                                title( 'Power Spectrogram - Braking Phase', 'FontSize', 18 )
                                                xlabel( ' Time (s) ', 'FontSize', 18 )
                                                ylabel( 'Frequencies of Interest (Hz)', 'FontSize', 18 )
                                                %Creates scaled image.
                                                %Take absolute value of spectrogram to convert complex numbers to amplitude
                                                
                                                c1 = colorbar;
                                                c1.Label.String = 'Power';
                                                c1.Label.FontSize = 16;
                                                c1.Limits = [ 0, abs( max( max( PowerSpectrum_EntireHop ) ) ) ];
                                                %Adds color bar to plot
                                                
                                                
                                                subplot( 3, 1, 3 )
                                                set(gcf,'Visible','on','Position',[50 6 1304 799],'Name','Spectrogram')
                                                imagesc(SigTime_PropulsionPhase, Freqs, PowerSpectrum_PropulsionPhase )
                                                set( gca, 'FontSize', 16 )
                                                title( 'Power Spectrogram - Propulsion Phase', 'FontSize', 18 )
                                                xlabel( ' Time (s) ', 'FontSize', 18 )
                                                ylabel( 'Frequencies of Interest (Hz)', 'FontSize', 18 )
                                                %Creates scaled image.
                                                %Take absolute value of spectrogram to convert complex numbers to amplitude
                                                
                                                c1 = colorbar;
                                                c1.Label.String = 'Power';
                                                c1.Label.FontSize = 16;
                                                c1.Limits = [ 0, abs( max( max( PowerSpectrum_EntireHop ) ) ) ];
                                                %Adds color bar to plot
                                                
                                                % pause
        
                                                close all

                                            end

                                        end


%% Add Data to Time Series Matrix
                                        
                                        %Initialize a matrix to hold the cumulative power for the current
                                        %hop
                                        PowerCumulativeSum_Onset2Offset = NaN( size( Specgram_Onset2Offset, 1 ), size( Specgram_Onset2Offset, 2 )  );

                                        %Initialize a matrix to hold the power time series for one hop
                                        PowerFrequency_Onset2Offset_TimeSeries_OneHop = NaN( size( Specgram_Onset2Offset, 2 ), 1 );
                                        

                                        for y = 1 : size( Specgram_Onset2Offset, 2 )
                                        
                                        
                                                PowerCumulativeSum_Onset2Offset( :, y ) = cumsum( PowerSpectrum_Onset2Offset( :, y ) );
                                                %Cumsum takes the cumulative sum. Ex: 5th value from cumsum = sum of
                                                %the 1st through 5th values of the power spectrum. I'll be using this
                                                %to find the median power frequency - I can either normalize the
                                                %cumulative sum by the final value and find the first frequency that si
                                                %greater than or equal to 0.5, or I can do the same
                                                %without normalizing and just multiplying the final value by 0.5

                                                %Add group number to 1st column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 1) = m;
    
                                                %Add participant number to 2nd column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 2) = n;
    
                                                %Add Limb ID to 3rdh column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 3) = a;
    
                                                %Add Muscle ID to 4th column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 4) = q;
    
                                                %Add Trial Number to 5th column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 5) = p;
    
                                                %Add Hop Number to 6th column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 6) = s;
    
                                                %Add Frame Number to 7th column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 7) = y;
    
                                                %Add Hopping Rate to 8th column
                                                PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 8)  = HoppingRate_ID_forTable(b);
    

                                                %If y corresponds to a flight phase frame, execute the
                                                %indented code below
                                                if y < BrakingPhaseBegin_Relative2Onset

                                                    %Add Phase ID to 9th column. 1 = flight phase
                                                    PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 9)  = 1;


                                                %If y corresponds to a braking phase frame, execute the
                                                %indented code below
                                                elseif  BrakingPhaseBegin_Relative2Onset <= y  &&...
                                                        y < PropulsionPhaseBegin_Relative2Onset

                                                    %Add Phase ID to 9th column. 2 = braking phase
                                                    PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 9)  = 2;


                                                %If y corresponds to a propulsion phase frame, execute
                                                %the indented code below
                                                elseif y >= PropulsionPhaseBegin_Relative2Onset

                                                    %Add Phase ID to 9th column. 3 = propulsion phase
                                                    PowerFrequency_Onset2Offset_TimeSeries(RowtoFill_PowerHz_Onset2Offset_TimeSeries, 9)  = 3;


                                                end
                                                


                                                
                                                PowerFrequency_Onset2Offset_TimeSeries( RowtoFill_PowerHz_Onset2Offset_TimeSeries, 10 ) = find( PowerCumulativeSum_Onset2Offset( :, y ) >= 0.5*PowerCumulativeSum_Onset2Offset( size( PowerCumulativeSum_Onset2Offset, 1 ), y ), 1, 'first' );
                                                %Here, I'm using the second option from the two I mentioned above.
                                                %find() allows you to look for the indices that meet certain criteria.
                                                %I'm looking for the value from the mth column of PowerCumulativeSum
                                                %that is greater than or equal to half of the maximum value. The second
                                                %argument specifies how many indices I want returned. The third
                                                %argument can be 'first' or 'last', meaning I want to take the first
                                                %nth values or the last nth values that meet the criteria. I only want
                                                %the first frequency.
                                                
                                                PowerFrequency_Onset2Offset_TimeSeries( RowtoFill_PowerHz_Onset2Offset_TimeSeries, 11 ) = sum( Freqs'.*PowerSpectrum_Onset2Offset( :, y ) ) / PowerCumulativeSum_Onset2Offset( size( PowerCumulativeSum_Onset2Offset, 1 ), y );
                                                %Mean Power Frequency = sum of the products of all power spectrum density
                                                %values with their corresponding frequency and dividing that by the sum of all
                                                %power spectrum density values

                                                %Add 1 to RowtoFill_PowerHz_Onset2Offset_TimeSeries so
                                                %the next loop iteration will fill the next row of PowerFrequency_Onset2Offset_TimeSeries
                                                RowtoFill_PowerHz_Onset2Offset_TimeSeries = RowtoFill_PowerHz_Onset2Offset_TimeSeries + 1;

                                                %Fill PowerFrequency Time Series for one hop - holds the
                                                %median power frequency
                                                PowerFrequency_Onset2Offset_TimeSeries_OneHop( y ) =...
                                                    find( PowerCumulativeSum_Onset2Offset( :, y ) >= 0.5*PowerCumulativeSum_Onset2Offset( size( PowerCumulativeSum_Onset2Offset, 1 ), y ), 1,...
                                                    'first' );

                                        end


%% Plot Median Hz Time Series

                                        %Create y-axis label for ankle angle - has degree sign
                                        s_Ankle = sprintf('Angle (%c) [- = PF/+ = DF]',char(176));

                                        %Only show the figure below if we told the code to show all figures
                                        %for Participant N
                                        if  strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Yes' ) || strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Y' )

                                                figure( 'Color','w','Position', [-1679 31 1680 999],'Name',['Check Median Hz Time Series, Hop ', num2str( s ), '  ', GroupList{m}, ' ', ParticipantList{n}, ' ' , LimbID{ a }, '  ', MuscleID{q}, ' ', HoppingRate_ID{b}, '  ' ,HoppingTrialNumber{p} ] )
        
                                                subplot( 5, 1, 1 )
                                                plot( ( 1 : size( Specgram_Onset2Offset, 2 ) ) ./ EMGSampHz, PowerFrequency_Onset2Offset_TimeSeries_OneHop, 'LineWidth', 2, 'Color','#0072BD' )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( PowerFrequency_Onset2Offset_TimeSeries_OneHop ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( PowerFrequency_Onset2Offset_TimeSeries_OneHop ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( PowerFrequency_Onset2Offset_TimeSeries_OneHop ) ] )
                                                ylabel( 'Median Power Frequency (Hz)' )
                                                title('Median Power Frequency Time Series')



                                                subplot( 5, 1, 2 )
                                                plot( ( 1 : size( Specgram_Onset2Offset, 2 ) ) ./ EMGSampHz, MuscleQTrialP_NormalizedEMG_Onset2Offset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( MuscleQTrialP_NormalizedEMG_Onset2Offset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( MuscleQTrialP_NormalizedEMG_Onset2Offset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( MuscleQTrialP_NormalizedEMG_Onset2Offset ) ] )
                                                ylabel( 'Normalized EMG (%Maximum Single Leg Vertical Jump' )
                                                title('Normalized EMG Time Series')



                                                subplot( 5, 1, 3 )
                                                plot( ( 1 : numel( AnklePower_MuscleOnsettoOffset ) ) ./ EMGSampHz, AnklePower_MuscleOnsettoOffset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnklePower_MuscleOnsettoOffset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnklePower_MuscleOnsettoOffset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( AnklePower_MuscleOnsettoOffset ) ] )
                                                xlim
                                                ylabel( 'Power (W/kg) [ - = Absorption, + = Generation ]' )
                                                title('Ankle Power Time Series')



                                                subplot( 5, 1, 4 )
                                                plot( ( 1 : numel( AnkleAngle_MuscleOnsettoOffset ) ) ./ EMGSampHz, AnkleAngle_MuscleOnsettoOffset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleAngle_MuscleOnsettoOffset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleAngle_MuscleOnsettoOffset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( AnkleAngle_MuscleOnsettoOffset ) ] )
                                                ylabel( s_Ankle )
                                                title('Ankle Angle Time Series')



                                                subplot( 5, 1, 5 )
                                                plot( ( 1 : numel( AnkleTorque_MuscleOnsettoOffset ) ) ./ EMGSampHz, AnkleTorque_MuscleOnsettoOffset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleTorque_MuscleOnsettoOffset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleTorque_MuscleOnsettoOffset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [min( AnkleTorque_MuscleOnsettoOffset ), 0 ] )
                                                ylabel( 'Normalized EMG (%Maximum Single Leg Vertical Jump' )
                                                title('Ankle Torque Time Series')
                                                
                                                 

                                                % pause

                                                %Save figure only if processing the last hop
                                                if s == numel( GContactBegin_FrameNumbers(:,p) )
                                                    
                                                    savefig( [ ParticipantList{n}, '_', 'MedianHzTimeSeries', '_', LimbID{a} '  ' MuscleID{q}  ' _ ' HoppingRate_ID{b}, num2str( s ),  '.fig' ] );

                                                end

                                                close all

                                        else

                                                figure( 'Color','w','Position', [-1679 31 1680 999],'Name',['Check Median Hz Time Series, Hop ', num2str( s ), '  ', GroupList{m}, ' ', ParticipantList{n}, ' ' , LimbID{ a }, '  ', MuscleID{q}, ' ', HoppingRate_ID{b}, '  ' ,HoppingTrialNumber{p} ] )
        
                                                subplot( 5, 1, 1 )
                                                plot( ( 1 : size( Specgram_Onset2Offset, 2 ) ) ./ EMGSampHz, PowerFrequency_Onset2Offset_TimeSeries_OneHop, 'LineWidth', 2, 'Color','#0072BD' )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( PowerFrequency_Onset2Offset_TimeSeries_OneHop ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( PowerFrequency_Onset2Offset_TimeSeries_OneHop ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( PowerFrequency_Onset2Offset_TimeSeries_OneHop ) ] )
                                                ylabel( 'Median Power Frequency (Hz)' )
                                                title('Median Power Frequency Time Series')



                                                subplot( 5, 1, 2 )
                                                plot( ( 1 : size( Specgram_Onset2Offset, 2 ) ) ./ EMGSampHz, MuscleQTrialP_NormalizedEMG_Onset2Offset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( MuscleQTrialP_NormalizedEMG_Onset2Offset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( MuscleQTrialP_NormalizedEMG_Onset2Offset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( MuscleQTrialP_NormalizedEMG_Onset2Offset ) ] )
                                                ylabel( 'Normalized EMG (%Maximum Single Leg Vertical Jump' )
                                                title('Normalized EMG Time Series')



                                                subplot( 5, 1, 3 )
                                                plot( ( 1 : numel( AnklePower_MuscleOnsettoOffset ) ) ./ EMGSampHz, AnklePower_MuscleOnsettoOffset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnklePower_MuscleOnsettoOffset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnklePower_MuscleOnsettoOffset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [min( AnklePower_MuscleOnsettoOffset ) 0 ] )
                                                xlim
                                                ylabel( 'Power (W/kg) [ - = Absorption, + = Generation ]' )
                                                title('Ankle Power Time Series')



                                                subplot( 5, 1, 4 )
                                                plot( ( 1 : numel( AnkleAngle_MuscleOnsettoOffset ) ) ./ EMGSampHz, AnkleAngle_MuscleOnsettoOffset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleAngle_MuscleOnsettoOffset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleAngle_MuscleOnsettoOffset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [0 max( AnkleAngle_MuscleOnsettoOffset ) ] )
                                                xlim
                                                ylabel( s_Ankle )
                                                title('Ankle Angle Time Series')



                                                subplot( 5, 1, 5 )
                                                plot( ( 1 : numel( AnkleTorque_MuscleOnsettoOffset ) ) ./ EMGSampHz, AnkleTorque_MuscleOnsettoOffset, 'LineWidth', 2 )
        
                                                L_BeginGContact = line( [ BrakingPhaseBegin_Relative2Onset / EMGSampHz, BrakingPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleTorque_MuscleOnsettoOffset ) ] );
                                                L_BeginGContact.LineStyle = '-';
                                                L_BeginGContact.LineWidth = 2.5;
                                                L_BeginGContact.Color = '#7E2F8E';
                                                
                                                L_BeginPropulsion = line( [ PropulsionPhaseBegin_Relative2Onset / EMGSampHz, PropulsionPhaseBegin_Relative2Onset / EMGSampHz  ], [ 0, max( AnkleTorque_MuscleOnsettoOffset ) ] );
                                                L_BeginPropulsion.LineStyle = '-';
                                                L_BeginPropulsion.LineWidth = 2.5;
                                                L_BeginPropulsion.Color = '#7E2F8E';
        
                                                xlabel('Time (s)')
                                                ylim( [min( AnkleTorque_MuscleOnsettoOffset ), 0 ] )
                                                ylabel( 'Normalized EMG (%Maximum Single Leg Vertical Jump' )
                                                title('Ankle Torque Time Series')
                                                

                                                %Save figure only if processing the last hop
                                                if s == numel( GContactBegin_FrameNumbers(:,p) )
                                                    
                                                    savefig( [ ParticipantList{n}, '_', 'MedianHzTimeSeries', '_', LimbID{a} '  ' MuscleID{q}  ' _ ' HoppingRate_ID{b}, num2str( s ),  '.fig' ] );

                                                end

                                                close all




                                        end

                                        





                                        
                                        %% Calculate Median and Mean Power Hz for Flight Phase
                                        
                                        PowerCumulativeSum_FlightPhase = NaN( size( Specgram_FlightPhase, 1 ), size( Specgram_FlightPhase, 2 )  );
                                        MedianPowerFrequency_FlightPhase_AllFrames = NaN( size( Specgram_FlightPhase, 2 ), 1 );
                                        MeanPowerFrequency_FlightPhase_AllFrames = NaN( size( Specgram_FlightPhase, 2 ), 1 );
                                        
                                        %Run the for loop once per time point
                                        for y = 1 : size( Specgram_FlightPhase, 2 )
                                        
                                        
                                                PowerCumulativeSum_FlightPhase( :, y ) = cumsum( PowerSpectrum_FlightPhase( :, y ) );
                                                %Cumsum takes the cumulative sum. Ex: 5th value from cumsum = sum of
                                                %the 1st through 5th values of the power spectrum. I'll be using this
                                                %to find the median power frequency - I can either normalize the
                                                %cumulative sum by the final value and find the first frequency that si
                                                %greater than or equal to 0.5, or I can do the same
                                                %without normalizing and just multiplying the final value by 0.5
                                                
                                                
                                                MedianPowerFrequency_FlightPhase_AllFrames( y ) = find( PowerCumulativeSum_FlightPhase( :, y ) >= 0.5*PowerCumulativeSum_FlightPhase( size( PowerCumulativeSum_FlightPhase, 1 ), y ), 1, 'first' );
                                                %Here, I'm using the second option from the two I mentioned above.
                                                %find() allows you to look for the indices that meet certain criteria.
                                                %I'm looking for the value from the mth column of PowerCumulativeSum
                                                %that is greater than or equal to half of the maximum value. The second
                                                %argument specifies how many indices I want returned. The third
                                                %argument can be 'first' or 'last', meaning I want to take the first
                                                %nth values or the last nth values that meet the criteria. I only want
                                                %the first frequency.
                                                
                                                MeanPowerFrequency_FlightPhase_AllFrames( y ) = sum( Freqs'.*PowerSpectrum_FlightPhase( :, y ) ) / PowerCumulativeSum_FlightPhase( size( PowerCumulativeSum_FlightPhase, 1 ), y );
                                                %Mean Power Frequency = sum of the products of all power spectrum density
                                                %values with their corresponding frequency and dividing that by the sum of all
                                                %power spectrum density values
                                        
                                        end
                                        
                                        %Find the average median/mean power frequency for the flight
                                        %phase
                                        AverageMedianPowerFrequency_FlightPhase( s ) = mean( MedianPowerFrequency_FlightPhase_AllFrames, 'omitnan' );
                                        AverageMeanPowerFrequency_FlightPhase( s ) = mean( MeanPowerFrequency_FlightPhase_AllFrames, 'omitnan' );
                                        
                                        %Find the time to peak median/mean power frequency for the flight
                                        %phase
                                        TimeToPeakMedianPowerFrequency_FlightPhase(s) = find( MedianPowerFrequency_FlightPhase_AllFrames == max( MedianPowerFrequency_FlightPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        TimeToPeakMeanPowerFrequency_FlightPhase(s) = find( MeanPowerFrequency_FlightPhase_AllFrames == max( MeanPowerFrequency_FlightPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        
                                        %Find the time to minimum median/mean power frequency for the flight
                                        %phase
                                        TimeToMinMedianPowerFrequency_FlightPhase(s) = find( MedianPowerFrequency_FlightPhase_AllFrames == min( MedianPowerFrequency_FlightPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        TimeToMinMeanPowerFrequency_FlightPhase(s) = find( MeanPowerFrequency_FlightPhase_AllFrames == min( MeanPowerFrequency_FlightPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        
                                        %Find the median/mean power frequency at the beginning of flight
                                        %phase
                                        MedianPowerFrequency_FirstFrameFlightPhase( s ) = MedianPowerFrequency_FlightPhase_AllFrames( 1 );
                                        MeanPowerFrequency_FirstFrameFlightPhase( s ) = MeanPowerFrequency_FlightPhase_AllFrames( 1 );

                                        %Find the median/mean power frequency at the endof flight
                                        %phase
                                        MedianPowerFrequency_LastFrameFlightPhase( s ) = MedianPowerFrequency_FlightPhase_AllFrames( size( Specgram_FlightPhase, 2 ) );
                                        MeanPowerFrequency_LastFrameFlightPhase( s ) = MeanPowerFrequency_FlightPhase_AllFrames( size( Specgram_FlightPhase, 2 ) );
                                        


                                        %% Calculate Median and Mean Power Hz for Braking Phase
                                        
                                        PowerCumulativeSum_BrakingPhase = NaN( size( Specgram_BrakingPhase, 1 ), size( Specgram_BrakingPhase, 2 )  );
                                        MedianPowerFrequency_BrakingPhase_AllFrames = NaN( size( Specgram_BrakingPhase, 2 ), 1 );
                                        MeanPowerFrequency_BrakingPhase_AllFrames = NaN( size( Specgram_BrakingPhase, 2 ), 1 );
                                        
                                        for y = 1 : size( Specgram_BrakingPhase, 2 )
                                        
                                        
                                                PowerCumulativeSum_BrakingPhase( :, y ) = cumsum( PowerSpectrum_BrakingPhase( :, y ) );
                                                %Cumsum takes the cumulative sum. Ex: 5th value from cumsum = sum of
                                                %the 1st through 5th values of the power spectrum. I'll be using this
                                                %to find the median power frequency - I can either normalize the
                                                %cumulative sum by the final value and find the first frequency that si
                                                %greater than or equal to 0.5, or I can do the same
                                                %without normalizing and just multiplying the final value by 0.5
                                                
                                                
                                                MedianPowerFrequency_BrakingPhase_AllFrames( y ) = find( PowerCumulativeSum_BrakingPhase( :, y ) >= 0.5*PowerCumulativeSum_BrakingPhase( size( PowerCumulativeSum_BrakingPhase, 1 ), y ), 1, 'first' );
                                                %Here, I'm using the second option from the two I mentioned above.
                                                %find() allows you to look for the indices that meet certain criteria.
                                                %I'm looking for the value from the mth column of PowerCumulativeSum
                                                %that is greater than or equal to half of the maximum value. The second
                                                %argument specifies how many indices I want returned. The third
                                                %argument can be 'first' or 'last', meaning I want to take the first
                                                %nth values or the last nth values that meet the criteria. I only want
                                                %the first frequency.
                                                
                                                MeanPowerFrequency_BrakingPhase_AllFrames( y ) = sum( Freqs'.*PowerSpectrum_BrakingPhase( :, y ) ) / PowerCumulativeSum_BrakingPhase( size( PowerCumulativeSum_BrakingPhase, 1 ), y );
                                                %Mean Power Frequency = sum of the products of all power spectrum density
                                                %values with their corresponding frequency and dividing that by the sum of all
                                                %power spectrum density values
                                        
                                        end
                                        
                                        
                                        AverageMedianPowerFrequency_BrakingPhase( s ) = mean( MedianPowerFrequency_BrakingPhase_AllFrames, 'omitnan' );
                                        AverageMeanPowerFrequency_BrakingPhase( s ) = mean( MeanPowerFrequency_BrakingPhase_AllFrames, 'omitnan' );
                                        
                                        %Find the time to peak median/mean power frequency for the Braking
                                        %phase
                                        TimeToPeakMedianPowerFrequency_BrakingPhase(s) = find( MedianPowerFrequency_BrakingPhase_AllFrames == max( MedianPowerFrequency_BrakingPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        TimeToPeakMeanPowerFrequency_BrakingPhase(s) = find( MeanPowerFrequency_BrakingPhase_AllFrames == max( MeanPowerFrequency_BrakingPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        
                                        %Find the time to minimum median/mean power frequency for the Braking
                                        %phase
                                        TimeToMinMedianPowerFrequency_BrakingPhase(s) = find( MedianPowerFrequency_BrakingPhase_AllFrames == min( MedianPowerFrequency_BrakingPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        TimeToMinMeanPowerFrequency_BrakingPhase(s) = find( MeanPowerFrequency_BrakingPhase_AllFrames == min( MeanPowerFrequency_BrakingPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                        
                                        %Find the median/mean power frequency at the beginning of Braking
                                        %phase
                                        MedianPowerFrequency_FirstFrameBrakingPhase( s ) = MedianPowerFrequency_BrakingPhase_AllFrames( 1 );
                                        MeanPowerFrequency_FirstFrameBrakingPhase( s ) = MeanPowerFrequency_BrakingPhase_AllFrames( 1 );

                                        %Find the median/mean power frequency at the endof Braking
                                        %phase
                                        MedianPowerFrequency_LastFrameBrakingPhase( s ) = MedianPowerFrequency_BrakingPhase_AllFrames( size( Specgram_BrakingPhase, 2 ) );
                                        MeanPowerFrequency_LastFrameBrakingPhase( s ) = MeanPowerFrequency_BrakingPhase_AllFrames( size( Specgram_BrakingPhase, 2 ) );
                                        
                                        
                                        
                                        
                                        %% Calculate Median and Mean Power Hz for Propulsion Phase
                                        
                                        PowerCumulativeSum_PropulsionPhase = NaN( size( Specgram_PropulsionPhase, 1 ), size( Specgram_PropulsionPhase, 2 )  );
                                        MedianPowerFrequency_PropulsionPhase_AllFrames = NaN( size( Specgram_PropulsionPhase, 2 ), 1 );
                                        MeanPowerFrequency_PropulsionPhase_AllFrames = NaN( size( Specgram_PropulsionPhase, 2 ), 1 );
                                        
                                        for y = 1 : size( Specgram_PropulsionPhase, 2 )
                                        
                                        
                                                PowerCumulativeSum_PropulsionPhase( :, y ) = cumsum( PowerSpectrum_PropulsionPhase( :, y ) );
                                                %Cumsum takes the cumulative sum. Ex: 5th value from cumsum = sum of
                                                %the 1st through 5th values of the power spectrum. I'll be using this
                                                %to find the median power frequency - I can either normalize the
                                                %cumulative sum by the final value and find the first frequency that si
                                                %greater than or equal to 0.5, or I can do the same
                                                %without normalizing and just multiplying the final value by 0.5
                                                
                                                
                                                MedianPowerFrequency_PropulsionPhase_AllFrames( y ) = find( PowerCumulativeSum_PropulsionPhase( :, y ) >= 0.5*PowerCumulativeSum_PropulsionPhase( size( PowerCumulativeSum_PropulsionPhase, 1 ), y ), 1, 'first' );
                                                %Here, I'm using the second option from the two I mentioned above.
                                                %find() allows you to look for the indices that meet certain criteria.
                                                %I'm looking for the value from the mth column of PowerCumulativeSum
                                                %that is greater than or equal to half of the maximum value. The second
                                                %argument specifies how many indices I want returned. The third
                                                %argument can be 'first' or 'last', meaning I want to take the first
                                                %nth values or the last nth values that meet the criteria. I only want
                                                %the first frequency.
                                                
                                                MeanPowerFrequency_PropulsionPhase_AllFrames( y ) = sum( Freqs'.*PowerSpectrum_PropulsionPhase( :, y ) ) / PowerCumulativeSum_PropulsionPhase( size( PowerCumulativeSum_PropulsionPhase, 1 ), y );
                                                %Mean Power Frequency = sum of the products of all power spectrum density
                                                %values with their corresponding frequency and dividing that by the sum of all
                                                %power spectrum density values
                                        
                                        end
                                        
                                        
                                        %If muscle de-activates before propulsion phase, set the
                                        %propulsion phase outcome variables to NaN
                                        if MuscleOffset_Relative2EntireHop_Frames( s ) <= BrakingPhase_HopSFrames( LengthofBrakingPhase_Onset2Offset( s ) )

                                            %Calculate average median and mean power Hz
                                            AverageMedianPowerFrequency_PropulsionPhase( s ) = NaN;
                                            AverageMeanPowerFrequency_PropulsionPhase( s ) = NaN;
                                            
                                            %Find the time to peak median/mean power frequency for the Propulsion
                                            %phase
                                            TimeToPeakMedianPowerFrequency_PropulsionPhase(s) = NaN;
                                            TimeToPeakMeanPowerFrequency_PropulsionPhase(s) = NaN;
                                            
                                            %Find the time to minimum median/mean power frequency for the Propulsion
                                            %phase
                                            TimeToMinMedianPowerFrequency_PropulsionPhase(s) = NaN;
                                            TimeToMinMeanPowerFrequency_PropulsionPhase(s) = NaN;
                                            
                                            %Find the median/mean power frequency at the beginning of Propulsion
                                            %phase
                                            MedianPowerFrequency_FirstFramePropulsionPhase( s ) = NaN;
                                            MeanPowerFrequency_FirstFramePropulsionPhase( s ) = NaN;
    
                                            %Find the median/mean power frequency at the endof Propulsion
                                            %phase
                                            MedianPowerFrequency_LastFramePropulsionPhase( s ) = NaN;
                                            MeanPowerFrequency_LastFramePropulsionPhase( s ) = NaN;

                                        %If muscle de-activates during propulsion phase, calculate the
                                        %propulsion phase outcome variables
                                        else

                                            %Calculate average median and mean power Hz
                                            AverageMedianPowerFrequency_PropulsionPhase( s ) = mean( MedianPowerFrequency_PropulsionPhase_AllFrames, 'omitnan' );
                                            AverageMeanPowerFrequency_PropulsionPhase( s ) = mean( MeanPowerFrequency_PropulsionPhase_AllFrames, 'omitnan' );
                                            
                                            %Find the time to peak median/mean power frequency for the Propulsion
                                            %phase
                                            TimeToPeakMedianPowerFrequency_PropulsionPhase(s) = find( MedianPowerFrequency_PropulsionPhase_AllFrames == max( MedianPowerFrequency_PropulsionPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                            TimeToPeakMeanPowerFrequency_PropulsionPhase(s) = find( MeanPowerFrequency_PropulsionPhase_AllFrames == max( MeanPowerFrequency_PropulsionPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                            
                                            %Find the time to minimum median/mean power frequency for the Propulsion
                                            %phase
                                            TimeToMinMedianPowerFrequency_PropulsionPhase(s) = find( MedianPowerFrequency_PropulsionPhase_AllFrames == min( MedianPowerFrequency_PropulsionPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                            TimeToMinMeanPowerFrequency_PropulsionPhase(s) = find( MeanPowerFrequency_PropulsionPhase_AllFrames == min( MeanPowerFrequency_PropulsionPhase_AllFrames ), 1 ) ./ EMGSampHz;
                                            
                                            %Find the median/mean power frequency at the beginning of Propulsion
                                            %phase
                                            MedianPowerFrequency_FirstFramePropulsionPhase( s ) = MedianPowerFrequency_PropulsionPhase_AllFrames( 1 );
                                            MeanPowerFrequency_FirstFramePropulsionPhase( s ) = MeanPowerFrequency_PropulsionPhase_AllFrames( 1 );
    
                                            %Find the median/mean power frequency at the endof Propulsion
                                            %phase
                                            MedianPowerFrequency_LastFramePropulsionPhase( s ) = MedianPowerFrequency_PropulsionPhase_AllFrames( size( Specgram_PropulsionPhase, 2 ) );
                                            MeanPowerFrequency_LastFramePropulsionPhase( s ) = MeanPowerFrequency_PropulsionPhase_AllFrames( size( Specgram_PropulsionPhase, 2 ) );

                                        end
                                        
                                        
                                        



                                        

    %% !! ADD Data to Activation Hz Table for R
                                            

                                        %If we have NOT added Participant N data, add it to table for
                                        %exporting
                                        if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                            %Add group number to 3rd column
                                            PowerHz_Table(RowtoFill, 1) = m;

                                            %Add participant number to 4th column
                                            PowerHz_Table(RowtoFill, 2) = n;

                                            %Add Limb ID to 5th column
                                            PowerHz_Table(RowtoFill, 3) = a;

                                            %Add Muscle ID to 6th column
                                            PowerHz_Table(RowtoFill, 4) = q;

                                            %Add Trial Number to 7th column
                                            PowerHz_Table(RowtoFill, 5) = p;

                                            %Add Hop Number to 8th column
                                            PowerHz_Table(RowtoFill, 6) = s;

                                            %Add Hopping Rate to 9th column
                                            PowerHz_Table(RowtoFill, 7)  = HoppingRate_ID_forTable(b);

                                            %Add preactivation onset time using entire hop cycle to first column
                                            PowerHz_Table(RowtoFill, 8) = AverageMedianPowerFrequency_FlightPhase(s);

                                            %Add preactivation onset time using flight phase only to 2nd column
                                            PowerHz_Table(RowtoFill, 9) = AverageMeanPowerFrequency_FlightPhase(s);

                                            %Add preactivation onset time using entire hop cycle to first column
                                            PowerHz_Table(RowtoFill, 10) = AverageMedianPowerFrequency_BrakingPhase(s);

                                            %Add preactivation onset time using Braking phase only to 2nd column
                                            PowerHz_Table(RowtoFill, 11) = AverageMeanPowerFrequency_BrakingPhase(s);

                                            %Add preactivation onset time using entire hop cycle to first column
                                            PowerHz_Table(RowtoFill, 12) = AverageMedianPowerFrequency_PropulsionPhase(s);

                                            %Add preactivation onset time using Propulsion phase only to 2nd column
                                            PowerHz_Table(RowtoFill, 13) = AverageMeanPowerFrequency_PropulsionPhase(s);

                                            %Find the time to peak median/mean power frequency for the flight
                                            %phase
                                            PowerHz_Table(RowtoFill, 14) = TimeToPeakMedianPowerFrequency_FlightPhase(s);
                                            PowerHz_Table(RowtoFill, 15) = TimeToPeakMeanPowerFrequency_FlightPhase(s);
                                            
                                            %Find the time to minimum median/mean power frequency for the flight
                                            %phase
                                            PowerHz_Table(RowtoFill, 16) = TimeToMinMedianPowerFrequency_FlightPhase(s);
                                            PowerHz_Table(RowtoFill, 17) = TimeToMinMeanPowerFrequency_FlightPhase(s);
                                            
                                            %Find the median/mean power frequency at the beginning of flight
                                            %phase
                                            PowerHz_Table(RowtoFill, 18) = MedianPowerFrequency_FirstFrameFlightPhase( s );
                                            PowerHz_Table(RowtoFill, 19) = MeanPowerFrequency_FirstFrameFlightPhase( s );
    
                                            %Find the median/mean power frequency at the endof flight
                                            %phase
                                            PowerHz_Table(RowtoFill, 20) = MedianPowerFrequency_LastFrameFlightPhase( s );
                                            PowerHz_Table(RowtoFill, 21) = MeanPowerFrequency_LastFrameFlightPhase( s );




                                            %Find the time to peak median/mean power frequency for the Braking
                                            %phase
                                            PowerHz_Table(RowtoFill, 22) = TimeToPeakMedianPowerFrequency_BrakingPhase(s);
                                            PowerHz_Table(RowtoFill, 23) = TimeToPeakMeanPowerFrequency_BrakingPhase(s);
                                            
                                            %Find the time to minimum median/mean power frequency for the Braking
                                            %phase
                                            PowerHz_Table(RowtoFill, 24) = TimeToMinMedianPowerFrequency_BrakingPhase(s);
                                            PowerHz_Table(RowtoFill, 25) = TimeToMinMeanPowerFrequency_BrakingPhase(s);
                                            
                                            %Find the median/mean power frequency at the beginning of Braking
                                            %phase
                                            PowerHz_Table(RowtoFill, 26) = MedianPowerFrequency_FirstFrameBrakingPhase( s );
                                            PowerHz_Table(RowtoFill, 27) = MeanPowerFrequency_FirstFrameBrakingPhase( s );
    
                                            %Find the median/mean power frequency at the endof Braking
                                            %phase
                                            PowerHz_Table(RowtoFill, 28) = MedianPowerFrequency_LastFrameBrakingPhase( s );
                                            PowerHz_Table(RowtoFill, 29) = MeanPowerFrequency_LastFrameBrakingPhase( s );




                                            %Find the time to peak median/mean power frequency for the Propulsion
                                            %phase
                                            PowerHz_Table(RowtoFill, 30) = TimeToPeakMedianPowerFrequency_PropulsionPhase(s);
                                            PowerHz_Table(RowtoFill, 31) = TimeToPeakMeanPowerFrequency_PropulsionPhase(s);
                                            
                                            %Find the time to minimum median/mean power frequency for the Propulsion
                                            %phase
                                            PowerHz_Table(RowtoFill, 32) = TimeToMinMedianPowerFrequency_PropulsionPhase(s);
                                            PowerHz_Table(RowtoFill, 33) = TimeToMinMeanPowerFrequency_PropulsionPhase(s);
                                            
                                            %Find the median/mean power frequency at the beginning of Propulsion
                                            %phase
                                            PowerHz_Table(RowtoFill, 34) = MedianPowerFrequency_FirstFramePropulsionPhase( s );
                                            PowerHz_Table(RowtoFill, 35) = MeanPowerFrequency_FirstFramePropulsionPhase( s );
    
                                            %Find the median/mean power frequency at the endof Propulsion
                                            %phase
                                            PowerHz_Table(RowtoFill, 36) = MedianPowerFrequency_LastFramePropulsionPhase( s );
                                            PowerHz_Table(RowtoFill, 37) = MeanPowerFrequency_LastFramePropulsionPhase( s );


                                            %Add between-limb tendon thickness for each participant to Column 14.
                                            %Add VAS Pain Rating to Column 15
                                            if strcmp( LimbID{ a}, 'InvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                        
                                                 %Set the between-limb morphology
                                                PowerHz_Table( RowtoFill, 14 )  = ATxMorphology( n );
                                                 
                                                 %Set theVAS rating
                                                PowerHz_Table( RowtoFill, 15)  = ATxVAS_Involved_PreferredHz( n );
        
        
                                            elseif strcmp( LimbID{ a}, 'InvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz')
                        
                                                 %Set the between-limb morphology
                                                PowerHz_Table( RowtoFill, 14 )  = ATxMorphology( n );
                                                 
                                                 %Set theVAS rating
                                                PowerHz_Table( RowtoFill, 15)  = ATxVAS_Involved_TwoHz( n );
        
                                                
                                            elseif strcmp( LimbID{ a}, 'InvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                        
                                                 %Set the between-limb morphology
                                                PowerHz_Table( RowtoFill, 14 )  = ATxMorphology( n );
                                                 
                                                 %Set theVAS rating
                                                PowerHz_Table( RowtoFill, 15)  = ATxVAS_Involved_TwoPoint3Hz( n );
        
        
                                            elseif strcmp( LimbID{ a}, 'NonInvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                        
                                                 %Set the between-limb morphology
                                                PowerHz_Table( RowtoFill, 14 )  = ATxMorphology( n );
                                                 
                                                 %Set theVAS rating
                                                PowerHz_Table( RowtoFill, 15)  = ATxVAS_NonInvolved_PreferredHz( n );
        
        
                                            elseif strcmp( LimbID{ a}, 'NonInvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz')
                        
                                                 %Set the between-limb morphology
                                                PowerHz_Table( RowtoFill, 14 )  = ATxMorphology( n );
                                                 
                                                 %Set theVAS rating
                                                PowerHz_Table( RowtoFill, 15)  = ATxVAS_NonInvolved_TwoHz( n );
        
                                                
                                            elseif strcmp( LimbID{ a}, 'NonInvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                        
                                                 %Set the between-limb morphology
                                                PowerHz_Table( RowtoFill, 14 )  = ATxMorphology( n );
                                                 
                                                 %Set theVAS rating
                                                PowerHz_Table( RowtoFill, 15)  = ATxVAS_NonInvolved_TwoPoint3Hz( n );
                        
                                            else
                        
                                                 %Set the between-limb morphology
                                                PowerHz_Table( RowtoFill, 14 )  = ControlMorphology( n );
                                                 
                                                 %Set theVAS rating
                                                PowerHz_Table( RowtoFill, 15)  = ControlVAS;
        
                                            end


                                           

                                            % Add one to RowtoFill so that next loop iteration will fill
                                            % in the next row
                                            RowtoFill = RowtoFill + 1;


                                        end%END IF STATEMENT FOR ADDING NEW DATA TO TABLE FOR EXPORT


                                    end%END S FOR LOOP

                                    %pause



%% Plot Mean and Median Hz for Each Phase
                                        
                                    if  strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Yes' ) || strcmp( cell2mat( ShowHoppingRatePlots_Cell  ), 'Y' )

                                        figure( 'Position', [264 226 1059 721], 'Color', 'w', 'Name', [ 'Mean and Median Power Hz Per Phase', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                        
                                        sgtitle('Mean and Median Power Hz Per Phase', 'FontSize', 20)
                                        
                                        subplot( 3, 2, 1 )
                                        plot( AverageMedianPowerFrequency_FlightPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Median Power Hz', 'FontSize', 16 )
                                        title( 'Median Power Hz - Flight Phase', 'FontSize', 18 )
                                        
                                        subplot( 3, 2, 2 )
                                        plot( AverageMeanPowerFrequency_FlightPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Mean Power Hz', 'FontSize', 16 )
                                        title( 'Mean Power Hz - Flight Phase', 'FontSize', 18 )
                                        
                                        
                                        
                                        subplot( 3, 2, 3 )
                                        plot( AverageMedianPowerFrequency_BrakingPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Median Power Hz', 'FontSize', 16 )
                                        title( 'Median Power Hz - Braking Phase', 'FontSize', 18 )
                                        
                                        subplot( 3, 2, 4 )
                                        plot( AverageMeanPowerFrequency_BrakingPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Mean Power Hz', 'FontSize', 16 )
                                        title( 'Mean Power Hz - Braking Phase', 'FontSize', 18 )
                                        
                                        
                                        
                                        subplot( 3, 2, 5 )
                                        plot( AverageMedianPowerFrequency_PropulsionPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Median Power Hz', 'FontSize', 16 )
                                        title( 'Median Power Hz - Propulsion Phase', 'FontSize', 18 )
                                        
                                        subplot( 3, 2, 6 )
                                        plot( AverageMeanPowerFrequency_PropulsionPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Mean Power Hz', 'FontSize', 16 )
                                        title( 'Mean Power Hz - Propulsion Phase', 'FontSize', 18 )

                                        savefig( [ ParticipantList{n}, '_', 'MeanandMedianHz', '_', LimbID{a} '  ' MuscleID{q}  ' _ ' HoppingRate_ID{b}, '.fig' ] );
                                        
                                        % pause
                                        
                                        close all

                                    else

                                        figure( 'Position', [264 226 1059 721], 'Color', 'w', 'Name', [ 'Mean and Median Power Hz Per Phase', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                        
                                        sgtitle('Mean and Median Power Hz Per Phase', 'FontSize', 20)
                                        
                                        subplot( 3, 2, 1 )
                                        plot( AverageMedianPowerFrequency_FlightPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Median Power Hz', 'FontSize', 16 )
                                        title( 'Median Power Hz - Flight Phase', 'FontSize', 18 )
                                        
                                        subplot( 3, 2, 2 )
                                        plot( AverageMeanPowerFrequency_FlightPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Mean Power Hz', 'FontSize', 16 )
                                        title( 'Mean Power Hz - Flight Phase', 'FontSize', 18 )
                                        
                                        
                                        
                                        subplot( 3, 2, 3 )
                                        plot( AverageMedianPowerFrequency_BrakingPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Median Power Hz', 'FontSize', 16 )
                                        title( 'Median Power Hz - Braking Phase', 'FontSize', 18 )
                                        
                                        subplot( 3, 2, 4 )
                                        plot( AverageMeanPowerFrequency_BrakingPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Mean Power Hz', 'FontSize', 16 )
                                        title( 'Mean Power Hz - Braking Phase', 'FontSize', 18 )
                                        
                                        
                                        
                                        subplot( 3, 2, 5 )
                                        plot( AverageMedianPowerFrequency_PropulsionPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Median Power Hz', 'FontSize', 16 )
                                        title( 'Median Power Hz - Propulsion Phase', 'FontSize', 18 )
                                        
                                        subplot( 3, 2, 6 )
                                        plot( AverageMeanPowerFrequency_PropulsionPhase, 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 15, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )
                                        xlabel( 'Hop Number', 'FontSize', 16 )
                                        ylabel( 'Mean Power Hz', 'FontSize', 16 )
                                        title( 'Mean Power Hz - Propulsion Phase', 'FontSize', 18 )

                                        savefig( [ ParticipantList{n}, '_', 'MeanandMedianHz', '_', LimbID{a} '  ' MuscleID{q}  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                        close all

                                    end


%% Store Data in Data Structure



                                    %Store the length of the entire hop phase, from onset to offset, in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofEntireHopPhase_Onset2Offset',...
                                        LengthofEntireHop_Onset2Offset);

                                    %Store the length of the flight phase, from onset to offset, in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofFlightPhase_Onset2Offset',...
                                        LengthofFlightPhase_Onset2Offset);

                                    %Store the length of the ground contact phase, from onset to offset, in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofGroundContactPhase_Onset2Offset',...
                                        LengthofGroundContactPhase_Onset2Offset);

                                    %Store the length of the braking phase, from onset to offset, in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofBrakingPhase_Onset2Offset',...
                                        LengthofBrakingPhase_Onset2Offset);

                                    %Store the length of the propulsion phase, from onset to offset, in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofPropulsionPhase_Onset2Offset',...
                                        LengthofPropulsionPhase_Onset2Offset);


                                end
                                
                                    
                                    
                                    
                            end%END B LOOP - HOPPING RATE

                        end

                    
                end
                
            end



            
        end
        
        
        
        
        
    end
    
    
end
                   
%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end







%% Section 4 - Calculate Participant and Group Means for PowerHz

    %Will use these to know which row to fill in the joint power and joint behavior index means
    RowtoFill_PowerHz_GroupMeans = 1;
    RowtoFill_PowerHz_ParticipantMeans = 1;
    
    %Initialize matrices to hold joint power and joint behavior index means
    PowerHz_GroupMeansPerHoppingRate = NaN( 1, 10 ); 
    PowerHz_ParticipantMeansPerHoppingRate = NaN( 1, 11 ); 
  

    %Need to know how many SD columns we need for Power_EntireContactPhase
    NumberofSD_Columns =  size( PowerHz_Table, 2 ) - 7 ;

    %Create a vector for filling in the SD columns
    ColumntoFill_SD_GroupMeans = ( size( PowerHz_Table, 2 ) - 3 + 1 ) : ( size( PowerHz_Table, 2 ) - 3 + NumberofSD_Columns ) ;
    ColumntoFill_SD_ParticipantMeans = ( size( PowerHz_Table, 2 ) - 2 + 1 ) : ( size( PowerHz_Table, 2 ) - 2 + NumberofSD_Columns ) ;

    %Initialize matrices to hold joint power and joint behavior index means
    PowerHz_GroupMeansPerHoppingRate = NaN( 1, ColumntoFill_SD_GroupMeans( end ) ); 
    PowerHz_ParticipantMeansPerHoppingRate = NaN( 1, ColumntoFill_SD_ParticipantMeans( end ) ); 


%Begin M For Loop - Loop Through Groups    
for m = 1 : numel(GroupList)

    %Use get field to create a new data structure containing the list of participants. List of participants is
    %stored under the second field of the structure (the list of groups)


    %Need to know which rows in the 1st column of PowerHzOnsetTime_Table correspond to the Mth
    %group
    PowerHz_IndicesForOneGroup = find( PowerHz_Table(:, 1) == m );

    %Create a new joint power matrix containing only Group M
    PowerHz_OneGroup = PowerHz_Table( PowerHz_IndicesForOneGroup, :);








    %If Group being processed is ATx, set Participant List to contain list of ATx participants.
    %If Group being processed is Controls, set Participant List to contain list of Control
    %participants.
    if strcmp( GroupList{m}, 'ATx' )

        ParticipantList = ATxParticipantList;

        ParticipantMass = ATxParticipantMass;

        HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};

        HoppingRate_ID_forTable = [0, 2, 2.3];
        
        LimbID = [1, 2];

    else

        ParticipantList = ControlParticipantList;

        ParticipantMass = ControlParticipantMass;

        HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};

        HoppingRate_ID_forTable = [0, 2, 2.3];
        
        LimbID = 1;

    end





%% Begin A For Loop - Loop Through Limbs

    for a = 1:numel(LimbID)


        %Need to know which rows in the 3rd column of PowerHz_OneGroup correspond to Limb A
        PowerHz_IndicesForOneLimb = find( PowerHz_OneGroup(:, 3) == a );


        %Create a new joint power matrix containing only Limb A
        PowerHz_OneLimb = PowerHz_OneGroup( PowerHz_IndicesForOneLimb, :);



%% Begin B For Loop - Loop Through Hopping Rates      

            for b = 1 : numel( HoppingRate_ID)



                %Need to know which rows in the 14th column of PowerHz_OneLimb correspond
                %to Hopping Rate B
                PowerHz_IndicesforOneRate = find( PowerHz_OneLimb( :, 7) == HoppingRate_ID_forTable(b) );

                %Create a new joint power matrix containing only Hopping Rate B
                PowerHz_OneRate = PowerHz_OneLimb( PowerHz_IndicesforOneRate, : );



                %Need to create a vector containing the values  for  each Muscle (1 for ankle, 2 for knee, 3
                %for hip )
                VectorofUniqueMuscles = unique( PowerHz_OneRate( :, 4 ) );



%% Begin C For Loop - Loop Through Each Muscle

                for c = 1 : length( VectorofUniqueMuscles ) 

                    
                    %Need to know which rows in the 7th column of PowerHz_OneRate
                    %correspond to Muscle C
                    PowerHz_IndicesforOneMuscle = find( PowerHz_OneRate( :, 4 ) == VectorofUniqueMuscles( c ) );

                    %Create a new Muscle power matrix containing only Muscle C
                    PowerHz_OneMuscle = PowerHz_OneRate( PowerHz_IndicesforOneMuscle, : );



                    %We want to take average of participant data, so fist create a vector containing
                    %Participant IDs. Use unique() to get rid of repeating IDs.
                    VectorofUniqueParticipants = unique( PowerHz_OneMuscle( :, 2 ) );



                    %Take average of Group_ID Column column of PowerHz_OneMuscle and store in the next row of Column 1 of PowerHz_GroupMeansPerHoppingRate
                    PowerHz_GroupMeansPerHoppingRate( RowtoFill_PowerHz_GroupMeans, 1 ) = mean(  PowerHz_OneMuscle(:,1), 1, 'omitnan'  );

                    %Take average of Limb_ID Column column of PowerHz_OneMuscle and store in the next row of Column 2 of PowerHz_GroupMeansPerHoppingRate
                    PowerHz_GroupMeansPerHoppingRate( RowtoFill_PowerHz_GroupMeans, 2 ) = mean(  PowerHz_OneMuscle(:,3), 1, 'omitnan'  );

                    %Take average of Muscle_ID Column column of PowerHz_OneMuscle and store in the next row of Column 3 of PowerHz_GroupMeansPerHoppingRate
                    PowerHz_GroupMeansPerHoppingRate( RowtoFill_PowerHz_GroupMeans, 3 ) = mean(  PowerHz_OneMuscle(:,4), 1, 'omitnan'  );

                    %Take average of HoppingRate_ID Column column of PowerHz_OneMuscle and store in the next row of Column 4 of PowerHz_GroupMeansPerHoppingRate
                    PowerHz_GroupMeansPerHoppingRate( RowtoFill_PowerHz_GroupMeans, 4 ) = mean(  PowerHz_OneMuscle(:,7), 1, 'omitnan'  );


                    %For loop for taking means and SD of each Power Hz variable
                    for z = 1 : numel( ColumntoFill_SD_GroupMeans )

                        %Find means of each Power Hz variable
                        PowerHz_GroupMeansPerHoppingRate( RowtoFill_PowerHz_GroupMeans, 4+z ) = mean(  PowerHz_OneMuscle( :, 7+z  ), 1, 'omitnan'  );

                        %Find standard deviation of each Power Hz variable
                        PowerHz_GroupMeansPerHoppingRate( RowtoFill_PowerHz_GroupMeans, ColumntoFill_SD_GroupMeans( z ) ) = std(  PowerHz_OneMuscle( :, 7+z  ), 1, 'omitnan'  );

                    end


                    %Add 1 to RowtoFill_PowerHz  so the next loop will fill the next row of PowerHz_GroupMeansPerHoppingRate
                    RowtoFill_PowerHz_GroupMeans =  RowtoFill_PowerHz_GroupMeans + 1;
                    





%% Begin E For Loop - Loop Through Participants
                    for e = 1 : numel( VectorofUniqueParticipants )
                    
                        %Find the indices for Participant E
                        PowerHz_IndicesforOneParticipant = find( PowerHz_OneMuscle( :, 2 ) == VectorofUniqueParticipants( e ) );
                    
                        %Create a new Muscle power matrix containing only Participant E
                        PowerHz_OneParticipant = PowerHz_OneMuscle( PowerHz_IndicesforOneParticipant, : );

                        

                        %Take average of Group_ID Column column of PowerHz_OneParticipant and store in the next row of Column 1 of PowerHz_ParticipantMeansPerHoppingRate
                        PowerHz_ParticipantMeansPerHoppingRate( RowtoFill_PowerHz_ParticipantMeans, 1 ) = mean(  PowerHz_OneParticipant( :, 1 ), 1, 'omitnan'  );

                        %Take average of Participant_ID Column column of PowerHz_OneParticipant and store in the next row of Column 2 of PowerHz_ParticipantMeansPerHoppingRate
                        PowerHz_ParticipantMeansPerHoppingRate( RowtoFill_PowerHz_ParticipantMeans, 2 ) = mean(  PowerHz_OneParticipant( :, 2 ), 1, 'omitnan'  );
    
                        %Take average of Limb_ID Column column of PowerHz_OneParticipant and store in the next row of Column 3 of PowerHz_ParticipantMeansPerHoppingRate
                        PowerHz_ParticipantMeansPerHoppingRate( RowtoFill_PowerHz_ParticipantMeans, 3 ) = mean(  PowerHz_OneParticipant( :, 3 ), 1, 'omitnan'  );
    
                        %Take average of Muscle_ID Column column of PowerHz_OneParticipant and store in the next row of Column 4 of PowerHz_ParticipantMeansPerHoppingRate
                        PowerHz_ParticipantMeansPerHoppingRate( RowtoFill_PowerHz_ParticipantMeans, 4 ) = mean(  PowerHz_OneParticipant( :, 4 ), 1, 'omitnan'  );
    
                        %Take average of HoppingRate_ID Column column of PowerHz_OneParticipant and store in the next row of Column 5 of PowerHz_ParticipantMeansPerHoppingRate
                        PowerHz_ParticipantMeansPerHoppingRate( RowtoFill_PowerHz_ParticipantMeans, 5 ) = mean(  PowerHz_OneParticipant( :, 7 ), 1, 'omitnan'  );
    


                        %For loop for taking means and SD of each Power Hz variable
                        for z = 1 : numel( ColumntoFill_SD_ParticipantMeans )
    
                            %Find means of each Power Hz variable
                            PowerHz_ParticipantMeansPerHoppingRate( RowtoFill_PowerHz_ParticipantMeans, 5+z ) = mean(  PowerHz_OneParticipant( :, 7+z  ), 1, 'omitnan'  );
    
                            %Find standard deviations of each Power Hz variable
                           PowerHz_ParticipantMeansPerHoppingRate( RowtoFill_PowerHz_ParticipantMeans, ColumntoFill_SD_ParticipantMeans( z ) ) = std(  PowerHz_OneParticipant( :, 7+z  ), 1, 'omitnan'  );
    
                        end

    

                        %Add 1 to RowtoFill_PowerHz  so the next loop will fill the next row of PowerHz_ParticipantMeansPerHoppingRate
                        RowtoFill_PowerHz_ParticipantMeans =  RowtoFill_PowerHz_ParticipantMeans + 1;


                       
                    end
                    
                    
                    
                end
                
                
            end
            
            
    end
    
end
    


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end


    
%% SECTION 5 - Export Tables



    %Create a list of variable names - these will be the column headers for the preactivation onset
    %table
    VariableNames_PowerHzTimeSeries = {'Group_ID','Participant_ID','Limb_ID','Muscle_ID','Trial_ID', 'Hop_ID', 'Frame_ID', 'HoppingRate_ID', 'Phase_ID'...
        'Median_PowerHz','Mean_PowerHz' };
    
    %Create table of preactivation onset data
    PowerHzTimeSeries_Table_forR = array2table(PowerFrequency_Onset2Offset_TimeSeries,'VariableNames',VariableNames_PowerHzTimeSeries);
        
    %Export preactivation onset table as .xlsx file
    writetable( PowerHzTimeSeries_Table_forR, [ 'PowerHzTime_Table_forR', QualvsPostQualData{l}, '_', GroupList{m}, '_', ParticipantList{n},'.xlsx' ] );
    
    %Save preactivation onset table in the data structure
    David_DissertationDataStructure = setfield(David_DissertationDataStructure, 'Post_Quals','AllGroups', 'PowerHzTimeSeries_Table',...
                                    PowerHzTimeSeries_Table_forR);




%Set variable names for creaitng tables from the PowerHz_GroupMeansPerHoppingRate and
%PowerHz_ParticipantMeansPerHoppingRate data
VariableNames_PowerHz_GroupMeans = {'Group_ID','Limb_ID','Muscle_ID','HoppingRate_ID',...
    'Mean_Median_PowerHz_FlightPhase','Mean_Mean_PowerHz_FlightPhase',...
    'Mean_Median_PowerHz_BrakingPhase','Mean_Mean_PowerHz_BrakingPhase',...
    'Mean_Median_PowerHz_PropulsionPhase','Mean_Mean_PowerHz_PropulsionPhase',...
    'Mean_TimeToPeakMedianPowerHz_FlightPhase', 'Mean_TimeToPeakMeanPowerHz_FlightPhase',...
    'Mean_TimeToMinMedianPowerHz_FlightPhase', 'Mean_TimeToMinMeanPowerHz_FlightPhase',...
    'Mean_MedianPowerHz_FirstFrameFlightPhase', 'Mean_MeanPowerHz_FirstFrameFlightPhase',...
    'Mean_MedianPowerHz_LastFrameFlightPhase', 'Mean_MeanPowerHz_LastFrameFlightPhase',...
    'Mean_TimeToPeakMedianPowerHz_BrakingPhase', 'Mean_TimeToPeakMeanPowerHz_BrakingPhase',...
    'Mean_TimeToMinMedianPowerHz_BrakingPhase', 'Mean_TimeToMinMeanPowerHz_BrakingPhase',...
    'Mean_MedianPowerHz_FirstFrameBrakingPhase', 'Mean_MeanPowerHz_FirstFrameBrakingPhase',...
    'Mean_MedianPowerHz_LastFrameBrakingPhase', 'Mean_MeanPowerHz_LastFrameBrakingPhase',...
    'Mean_TimeToPeakMedianPowerHz_PropulsionPhase', 'Mean_TimeToPeakMeanPowerHz_PropulsionPhase',...
    'Mean_TimeToMinMedianPowerHz_PropulsionPhase', 'Mean_TimeToMinMeanPowerHz_PropulsionPhase',...
    'Mean_MedianPowerHz_FirstFramePropulsionPhase', 'Mean_MeanPowerHz_FirstFramePropulsionPhase',...
    'Mean_MedianPowerHz_LastFramePropulsionPhase', 'Mean_MeanPowerHz_LastFramePropulsionPhase',...
    'SD_Median_PowerHz_FlightPhase','SD_Mean_PowerHz_FlightPhase',...
    'SD_Median_PowerHz_BrakingPhase','SD_Mean_PowerHz_BrakingPhase',...
    'SD_Median_PowerHz_PropulsionPhase','SD_Mean_PowerHz_PropulsionPhase',...
    'SD_TimeToPeakMedianPowerHz_FlightPhase', 'SD_TimeToPeakMeanPowerHz_FlightPhase',...
    'SD_TimeToMinMedianPowerHz_FlightPhase', 'SD_TimeToMinMeanPowerHz_FlightPhase',...
    'SD_MedianPowerHz_FirstFrameFlightPhase', 'SD_MeanPowerHz_FirstFrameFlightPhase',...
    'SD_MedianPowerHz_LastFrameFlightPhase', 'SD_MeanPowerHz_LastFrameFlightPhase',...
    'SD_TimeToPeakMedianPowerHz_BrakingPhase', 'SD_TimeToPeakMeanPowerHz_BrakingPhase',...
    'SD_TimeToMinMedianPowerHz_BrakingPhase', 'SD_TimeToMinMeanPowerHz_BrakingPhase',...
    'SD_MedianPowerHz_FirstFrameBrakingPhase', 'SD_MeanPowerHz_FirstFrameBrakingPhase',...
    'SD_MedianPowerHz_LastFrameBrakingPhase', 'SD_MeanPowerHz_LastFrameBrakingPhase',...
    'SD_TimeToPeakMedianPowerHz_PropulsionPhase', 'SD_TimeToPeakMeanPowerHz_PropulsionPhase',...
    'SD_TimeToMinMedianPowerHz_PropulsionPhase', 'SD_TimeToMinMeanPowerHz_PropulsionPhase',...
    'SD_MedianPowerHz_FirstFramePropulsionPhase', 'SD_MeanPowerHz_FirstFramePropulsionPhase',...
    'SD_MedianPowerHz_LastFramePropulsionPhase', 'SD_MeanPowerHz_LastFramePropulsionPhase'  };

%Create a table from the PowerHz_GroupMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( PowerHz_GroupMeansPerHoppingRate, 'VariableNames', VariableNames_PowerHz_GroupMeans ), 'PostQuals_PowerHz_GroupMeansPerHoppingRate_OneControlLimb.xlsx' );







%Set variable names for creaitng tables from the PowerHz_GroupMeansPerHoppingRate and
%PowerHz_ParticipantMeansPerHoppingRate data
VariableNames_PowerHz_ParticipantMeans = {'Group_ID','Participant_ID','Limb_ID','Muscle_ID','HoppingRate_ID',...
    'Mean_Median_PowerHz_FlightPhase','Mean_Mean_PowerHz_FlightPhase',...
    'Mean_Median_PowerHz_BrakingPhase','Mean_Mean_PowerHz_BrakingPhase',...
    'Mean_Median_PowerHz_PropulsionPhase','Mean_Mean_PowerHz_PropulsionPhase',...
    'Mean_TimeToPeakMedianPowerHz_FlightPhase', 'Mean_TimeToPeakMeanPowerHz_FlightPhase',...
    'Mean_TimeToMinMedianPowerHz_FlightPhase', 'Mean_TimeToMinMeanPowerHz_FlightPhase',...
    'Mean_MedianPowerHz_FirstFrameFlightPhase', 'Mean_MeanPowerHz_FirstFrameFlightPhase',...
    'Mean_MedianPowerHz_LastFrameFlightPhase', 'Mean_MeanPowerHz_LastFrameFlightPhase',...
    'Mean_TimeToPeakMedianPowerHz_BrakingPhase', 'Mean_TimeToPeakMeanPowerHz_BrakingPhase',...
    'Mean_TimeToMinMedianPowerHz_BrakingPhase', 'Mean_TimeToMinMeanPowerHz_BrakingPhase',...
    'Mean_MedianPowerHz_FirstFrameBrakingPhase', 'Mean_MeanPowerHz_FirstFrameBrakingPhase',...
    'Mean_MedianPowerHz_LastFrameBrakingPhase', 'Mean_MeanPowerHz_LastFrameBrakingPhase',...
    'Mean_TimeToPeakMedianPowerHz_PropulsionPhase', 'Mean_TimeToPeakMeanPowerHz_PropulsionPhase',...
    'Mean_TimeToMinMedianPowerHz_PropulsionPhase', 'Mean_TimeToMinMeanPowerHz_PropulsionPhase',...
    'Mean_MedianPowerHz_FirstFramePropulsionPhase', 'Mean_MeanPowerHz_FirstFramePropulsionPhase',...
    'Mean_MedianPowerHz_LastFramePropulsionPhase', 'Mean_MeanPowerHz_LastFramePropulsionPhase',...
    'SD_Median_PowerHz_FlightPhase','SD_Mean_PowerHz_FlightPhase',...
    'SD_Median_PowerHz_BrakingPhase','SD_Mean_PowerHz_BrakingPhase',...
    'SD_Median_PowerHz_PropulsionPhase','SD_Mean_PowerHz_PropulsionPhase',...
    'SD_TimeToPeakMedianPowerHz_FlightPhase', 'SD_TimeToPeakMeanPowerHz_FlightPhase',...
    'SD_TimeToMinMedianPowerHz_FlightPhase', 'SD_TimeToMinMeanPowerHz_FlightPhase',...
    'SD_MedianPowerHz_FirstFrameFlightPhase', 'SD_MeanPowerHz_FirstFrameFlightPhase',...
    'SD_MedianPowerHz_LastFrameFlightPhase', 'SD_MeanPowerHz_LastFrameFlightPhase',...
    'SD_TimeToPeakMedianPowerHz_BrakingPhase', 'SD_TimeToPeakMeanPowerHz_BrakingPhase',...
    'SD_TimeToMinMedianPowerHz_BrakingPhase', 'SD_TimeToMinMeanPowerHz_BrakingPhase',...
    'SD_MedianPowerHz_FirstFrameBrakingPhase', 'SD_MeanPowerHz_FirstFrameBrakingPhase',...
    'SD_MedianPowerHz_LastFrameBrakingPhase', 'SD_MeanPowerHz_LastFrameBrakingPhase',...
    'SD_TimeToPeakMedianPowerHz_PropulsionPhase', 'SD_TimeToPeakMeanPowerHz_PropulsionPhase',...
    'SD_TimeToMinMedianPowerHz_PropulsionPhase', 'SD_TimeToMinMeanPowerHz_PropulsionPhase',...
    'SD_MedianPowerHz_FirstFramePropulsionPhase', 'SD_MeanPowerHz_FirstFramePropulsionPhase',...
    'SD_MedianPowerHz_LastFramePropulsionPhase', 'SD_MeanPowerHz_LastFramePropulsionPhase'  };

%Create a table from the PowerHz_ParticipantMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( PowerHz_ParticipantMeansPerHoppingRate, 'VariableNames', VariableNames_PowerHz_ParticipantMeans ), 'PostQuals_PowerHz_ParticipantMeansPerHoppingRate_OneControlLimb.xlsx' );

    





%Create a list of variable names - these will be the column headers for the preactivation onset
%table
VariableNames_IndividualHops = {'Group_ID','Participant_ID','Limb_ID','Muscle_ID','Trial_ID', 'Hop_ID', 'HoppingRate_ID',...
    'Median_PowerHz_FlightPhase','Mean_PowerHz_FlightPhase',...
    'Median_PowerHz_BrakingPhase','Mean_PowerHz_BrakingPhase',...
    'Median_PowerHz_PropulsionPhase','Mean_PowerHz_PropulsionPhase',...
    'TimeToPeakMedianPowerHz_FlightPhase', 'TimeToPeakMeanPowerHz_FlightPhase',...
    'TimeToMinMedianPowerHz_FlightPhase', 'TimeToMinMeanPowerHz_FlightPhase',...
    'MedianPowerHz_FirstFrameFlightPhase', 'MeanPowerHz_FirstFrameFlightPhase',...
    'MedianPowerHz_LastFrameFlightPhase', 'MeanPowerHz_LastFrameFlightPhase',...
    'TimeToPeakMedianPowerHz_BrakingPhase', 'TimeToPeakMeanPowerHz_BrakingPhase',...
    'TimeToMinMedianPowerHz_BrakingPhase', 'TimeToMinMeanPowerHz_BrakingPhase',...
    'MedianPowerHz_FirstFrameBrakingPhase', 'MeanPowerHz_FirstFrameBrakingPhase',...
    'MedianPowerHz_LastFrameBrakingPhase', 'MeanPowerHz_LastFrameBrakingPhase',...
    'TimeToPeakMedianPowerHz_PropulsionPhase', 'TimeToPeakMeanPowerHz_PropulsionPhase',...
    'TimeToMinMedianPowerHz_PropulsionPhase', 'TimeToMinMeanPowerHz_PropulsionPhase',...
    'MedianPowerHz_FirstFramePropulsionPhase', 'MeanPowerHz_FirstFramePropulsionPhase',...
    'MedianPowerHz_LastFramePropulsionPhase', 'MeanPowerHz_LastFramePropulsionPhase'};

%Create table of preactivation onset data
PowerHz_Table_forR = array2table(PowerHz_Table,'VariableNames',VariableNames_IndividualHops);
    
%Export preactivation onset table as .xlsx file
writetable(PowerHz_Table_forR,'POSTQUALS_PowerHzTime_Table_forR.xlsx');

%Save preactivation onset table in the data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure, QualvsPostQualData{l}, 'AllGroups', 'PowerHz_Table', PowerHz_Table_forR);





%Create a list of variable names - these will be the column headers for the preactivation onset
%table
VariableNames_PowerHzTimeSeries = {'Group_ID','Participant_ID','Limb_ID','Muscle_ID','Trial_ID', 'Hop_ID', 'Frame_ID', 'HoppingRate_ID', 'Phase_ID'...
    'Median_PowerHz','Mean_PowerHz' };

%Create table of preactivation onset data
PowerHzTimeSeries_Table_forR = array2table(PowerFrequency_Onset2Offset_TimeSeries,'VariableNames',VariableNames_PowerHzTimeSeries);
    
%Export preactivation onset table as .xlsx file
writetable(PowerHzTimeSeries_Table_forR,'POSTQUALS_PowerHzTime_Table_forR.xlsx');

%Save preactivation onset table in the data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure, QualvsPostQualData{l}, 'AllGroups', 'PowerHzTimeSeries_Table', PowerHzTimeSeries_Table_forR);



% 
% 
% clearvars -except David_DissertationDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList DataCategories_HoppingKinematicsKinetics ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz ATxParticipantMass ControlParticipantMass CreateStruct
% 
% clc




%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

