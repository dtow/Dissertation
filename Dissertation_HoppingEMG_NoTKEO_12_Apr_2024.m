%% SECTION 1 - Load Data Structure

%Load data structure
load( 'Post-Quals Data/Data Structure/Current Version/EMG DataStructure/David_DissertationEMGDataStructure_MinAdj_18Jun2024.mat');


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
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36', 'ATx49', 'ATx39', 'ATx74', 'ATx65',...
    'ATx14' };
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45', 'HC44', 'HC48', 'HC65' };
%4th field = data type
DataCategories = {'HoppingEMG'};
%5th field = limb ID
EMGID = {'MVIC'};
%6th field = trial number
HoppingTrialNumber = {'Trial1'};

%Create string with degree symbol for plotting ankle angle
string_Angle = sprintf('Angle (%c) [- = PF]',char(176));

%Load the Mass data from the data structure
MassLog = David_DissertationDataStructure.Post_Quals.AllGroups.MassLog;


%String for labeling y-axis of non-normalized EMG
RawHoppingUnits_string = 'Voltage (mV)';


%Specify sampling rates for GRF, EMG, kinematics/kinetics
GRFSampHz = 1500;
EMGSampHz = 1500;
MoCapSampHz = 250;


   

%Load the Morphology data from the data structure
MorphologyLog = David_DissertationDataStructure.Post_Quals.AllGroups.MorphologyLog;

%Load the VAS data from the data structure
VASLog = David_DissertationDataStructure.Post_Quals.ATx.AllParticipants.VASLog;

    %Control Group
ControlVAS = 0;



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end










%% SECTION 3 - Process Hopping EMG
    


    
%Want to clear the errors for the new section
lasterror = [];
    


%Need to downsample EMG to match number of kinematic data points
NumberofElementstoAverageforDownSampling = EMGSampHz / MoCapSampHz;

%Set time step for integrating EMG
TimeInterval_forIntegratingEMG = 1 ./ EMGSampHz;




    %Create a prompt so we can tell the code whether we've added any new participants
    ReprocessingDatPrompt =  'Are You Reprocessing Data?' ;

    %Use inputdlg function to create a dialogue box for the prompt created above.
    %First arg is prompt, 2nd is title
    ReprocessingData_Cell = inputdlg( [ '\fontsize{15}' ReprocessingDatPrompt ], 'Are You Reprocessing Data?', [1 150], {'No'} ,CreateStruct);





    %If we are NOT reprocessing data, access JointBehaviorIndex and Power_EntireContactPhase from the
    %data structure
    if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' )

        %Save the Power_EntireContactPhase table in the data structure
        PreactivationOnsetTime_Table = David_DissertationEMGDataStructure.Post_Quals.AllGroups.PreactivationOnsetTime_Matrix;
        
        
        %RowtoFill for JointBehaviorIndex = current number of rows in JointBehaviorIndex
        RowtoFill_OnsetTable = size( PreactivationOnsetTime_Table, 1) + 1;


    %If we ARE reprocessing data, initialize JointBehaviorIndex and Power_EntireContactPhase
    else
        
        %Initialize table to hold preactivation onset times
        PreactivationOnsetTime_Table = NaN( 1, 14 );
        
        %This variable will tell the code which row of PreactivationOnsetTime_Table to fill    
        RowtoFill_OnsetTable = 1;
      
    end




    %If you are NOT reprocessing data, ask whether we have added any new participants
    if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' )
    
        
        %Create a prompt so we can tell the code whether we've added any new participants
        AddedNewParticipantPrompt =  'Have You Added A New Participant?' ;
    
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
ShowAnyPlotsPrompt =  'Show Any Plots ?' ;

%Use inputdlg function to create a dialogue box for the prompt created above.
%First arg is prompt, 2nd is title
ShowAnyPlots_Cell = inputdlg( [ '\fontsize{15}' ShowAnyPlotsPrompt ], 'Show Any Plots?', [1 150], {'No'} ,CreateStruct);



for l = 1 : numel(QualvsPostQualData)
    

%% !! Begin M For Loop - Loop Through Groups    
    
    for m = 1% : numel(GroupList)
        

        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{m}, 'ATx' )
            
            ParticipantList = ATxParticipantList;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        
        HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
        
        

        
        
%% !! Begin N For Loop - Loop Through Participants        
        
        for n = 13 %numel(ParticipantList)
            
            
            %If you are NOT reprocessing data, ask whether we have added any new participants
            if strcmp( cell2mat( AddedNewParticipant_Cell ), 'Yes' ) || strcmp( cell2mat( AddedNewParticipant_Cell ), 'Y' )
            
            
                %Create a prompt so we can tell the code whether we've added any new participants
                AddParticipantNDataPrompt = [ 'Have You Added ', ParticipantList{ n }, 's Data?' ];
                
                %Use inputdlg function to create a dialogue box for the prompt created above.
                %First arg is prompt, 2nd is title
                AddedParticipantNData_Cell = inputdlg( [ '\fontsize{15}' AddParticipantNDataPrompt ], [ 'Have You Added ', ParticipantList{ n }, 's Data?' ], [1 150], {'Yes'} ,CreateStruct);
            
            
            end



            
            
            if strcmp( cell2mat( AddedNewParticipant_Cell ), 'Yes' ) || strcmp( cell2mat( AddedNewParticipant_Cell ), 'Y' ) || strcmp( cell2mat( ShowAnyPlots_Cell ), 'Yes' ) || strcmp( cell2mat( ShowAnyPlots_Cell ), 'Y' )
                
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
                HoppingRate_ID_forTable = [ 0, 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx24'  ) 
                
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
                HoppingRate_ID_forTable = [ 2, 2.33 ];




            elseif strcmp( ParticipantList{n}, 'ATx19'  ) || strcmp( ParticipantList{n}, 'ATx65'  )
             
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
                HoppingRate_ID_forTable = [ 2, 2.33 ];



            elseif strcmp( ParticipantList{n}, 'ATx12'  ) || strcmp( ParticipantList{n}, 'ATx14'  ) || strcmp( ParticipantList{n}, 'ATx27'  ) || strcmp( ParticipantList{n}, 'ATx34'  ) || strcmp( ParticipantList{n}, 'ATx44'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx50'  ) || strcmp( ParticipantList{n}, 'ATx100'  )
             
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
                HoppingRate_ID_forTable = [ 0, 2, 2.33 ]; 
                
                



            elseif strcmp( ParticipantList{ n }, 'HC11'  ) || strcmp( ParticipantList{n}, 'HC42'  )
                
                %Process only the right limb of HC11
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %HC11 has only the 2.0 and 2.33 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ n }, 'HC17'  ) || strcmp( ParticipantList{ n }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ n }, 'HC32'  ) || strcmp( ParticipantList{ n }, 'HC34'  ) || strcmp( ParticipantList{ n }, 'HC45'  ) ||...
                    strcmp( ParticipantList{ n }, 'HC48'  ) ||strcmp( ParticipantList{ n }, 'HC65'  ) || strcmp( ParticipantList{ n }, 'HC68'  )
                
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
                HoppingRate_ID_forTable = [ 0, 2, 2.33 ];


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
                 HoppingRate_ID_forTable = [ 0, 2, 2.33 ];
                
                               
            end
            
            
            
            
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ n }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ n }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
            
        
            
            
            %Initalize array to hold peak MVICs - one element per muscle
             PeakMVICs = NaN(1,5);
            
             

             
%% !! BEGIN O For Loop - Loop Through Data Categories             
            for o = 1 : numel(DataCategories)
                


%% !! Begin A For Loop - Loop Through Limbs                
                
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
                         MuscleID = {'RMGas','RLGas','RSol','RPL', 'RTA' };
                         
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



                    elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx14 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx14, Non-Involved Limb is Right Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx14 non-involved limb
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





                    elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};





                    elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

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

                    %LLGas for HC53 seems questionable. Don't include in the analysis     
                    elseif strcmp( ParticipantList{n}, 'HC53'  ) && strcmp( LimbID{ a}, 'LeftLimb')

                        %Set the muscle ID list for HC53 left limb
                        MuscleID = {'LMGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx49'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx49 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx49, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx40'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx49 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ n }, 'ATx50'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx50 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx50, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ n }, 'ATx50'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx50 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx65'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx65 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx65, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx65'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx65 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx74 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx74, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx74 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                         
                         
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
                    
                     



                    
                    
                    %Create a variable to hold the resting EMG data
                    RestingEMG = David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).HoppingEMG.RestingEMG;

                    


                    
                    
                    
                    
                    
                        
%% !! Begin Q For Loop - Loop Throuigh Muscles                        
                        
                        for q = 1%1 : numel(MuscleID)
                           


                            %If we are NOT completely reprocessing data (meaning we didn't reset the Preactivation matrix), ask whether we want to reprocess
                            %pre-activation. We might want to say no if we processed pre-activation but
                            %need to re-process the linear enveloped and normalized data
                            if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'no' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'n' )

                                %Create a prompt so we can decide whether to reprocess pre-activation
                                ReprocessPreactivationPrompt = [ 'Reprocess Preactivation for  ', ParticipantList{n}, ', ', MuscleID{ q }, '?' ];
                    
                                %Use inputdlg function to create a dialogue box for the prompt created above.
                                %First arg is prompt, 2nd is title
                                ReprocessPreactivation_Cell = inputdlg( [ '\fontsize{15}' ReprocessPreactivationPrompt ], [ 'Reprocess Preactivation for  ', ParticipantList{n}, ', ', MuscleID{ q }, '?' ], [1 150], {'No'} ,CreateStruct);

                            %If we selected to reprocess data, automatically set
                            %ReprocessPreactivation_Cell to Yes
                            else

                                ReprocessPreactivation_Cell = {'Yes'};

                            end



                            if strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Yes' )


                                %Create a prompt so we can decide whether to reprocess pre-activation
                                ReprocessSDPreactivationPrompt = [ 'Reprocess SD Preactivation for  ', ParticipantList{n}, ', ', MuscleID{ q }, '?' ];
                    
                                %Use inputdlg function to create a dialogue box for the prompt created above.
                                %First arg is prompt, 2nd is title
                                ReprocessSDPreactivation_Cell = inputdlg( [ '\fontsize{15}' ReprocessSDPreactivationPrompt ], [ 'Reprocess SD Preactivation for  ', ParticipantList{n}, ', ', MuscleID{ q }, '?' ], [1 150], {'No'} ,CreateStruct);



                                %Create a prompt so we can decide whether to reprocess pre-activation
                                ReprocessSMDPreactivationPrompt = [ 'Reprocess SMD Preactivation for  ', ParticipantList{n}, ', ', MuscleID{ q }, '?' ];
                    
                                %Use inputdlg function to create a dialogue box for the prompt created above.
                                %First arg is prompt, 2nd is title
                                ReprocessSMDPreactivation_Cell = inputdlg( [ '\fontsize{15}' ReprocessSMDPreactivationPrompt ], [ 'Reprocess SMD Preactivation for  ', ParticipantList{n}, ', ', MuscleID{ q }, '?' ], [1 150], {'No'} ,CreateStruct);


                            end
                                



                            %Only show the figure below if we told the code to show all figures
                            %for Participant N
                            if  strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Yes' )
                                
                                ShowPreactivationPlots_Cell = { 'Yes' };

                            elseif strcmp( cell2mat( ReprocessPreactivation_Cell ), 'No' )
                                
                                ShowPreactivationPlots_Cell = { 'No' };


                            elseif strcmp( cell2mat( ShowPlots_Cell ), 'Yes' ) 

                                %Create a prompt so we can manually enter the group of interest
                                ShowPreactivationPlotsPrompt = [ 'Show Preactivation Plots for  ', ParticipantList{n}, ', ', MuscleID{ q }, '?' ];
                    
                                %Use inputdlg function to create a dialogue box for the prompt created above.
                                %First arg is prompt, 2nd is title
                                ShowPreactivationPlots_Cell = inputdlg( [ '\fontsize{15}' ShowPreactivationPlotsPrompt ], 'Show Preactivation Plots?', [1 150], {'No'} ,CreateStruct);

                            end



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






    %% Find mean of the Qth muscle's resting EMG. 
                            MuscleQ_RestingEMG = RestingEMG.( MuscleID{ q } );

                            MuscleQ_RestingEMGMean = mean( RestingEMG.(MuscleID{ q } ) );

                            %Need to index into data structure and find the peak MVIC value for the Qth
                            %muscle
                            MuscleQ_MVIC_Value = David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).HoppingEMG.( LimbID{a} ).PeakMVICs.( MuscleID{ q } );

                            MuscleQ_MVIC_Value_RectifiedNoBandpass = David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).HoppingEMG.( LimbID{a} ).PeakMVICs_SLHR_RectifiedNoBandpass.( MuscleID{ q } );


                            
                            
 %% !! BEGIN B FOR LOOP - Hopping Rate ID                           
                            for b = numel( HoppingRate_ID )



                                
                                %Use get field to create a new data structure containing the kinematic and kinetic data for a given hopping rate. Stored under the 5th field of the structure (the list of MTUs)
                                IndexingIntoData_HoppingRateB_DataStructure = David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).UseforIndexingIntoData.( LimbID{ a } ).( HoppingRate_ID{b} );
                                
                                
                                
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
                                
                                
                    
                                
    %% !! Begin P For Loop - Once For Each Trial (Set of Hops)

                                for p = 1 : numel(HoppingTrialNumber)


                                    %% Index into Data Structure, within P Loop (Hopping Trial #)
    
                                    %Use getfield to create a new data structure containing the EMG data for
                                    %the pth hopping trial
                                    HoppingEMG_TrialP_Table = David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).HoppingEMG.( LimbID{a} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{ p } );

                                    %Use getfield to create a new data structure containing the GRF
                                    %and Kinematics data for the Pth hopping trial
                                    HoppingGRFandKin_TrialP_Table = David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).HoppingKinematicsKinetics.( LimbID{a} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{ p } );


                                    %Use getfield to create a new data structure containing the EMG data for
                                    %the Qth muscle in the pth hopping trial
                                    MuscleQTrialP = HoppingEMG_TrialP_Table.( MuscleID{ q } );

                                    %Pull out the vertical GRF data for the Pth hopping trial
                                    vGRFTrialP = HoppingGRFandKin_TrialP_Table.FP3_2;

                                    

                                    %Pull out the sagittal plane ankle joint angle 
                                    AnkleSagittalAngle =...
                                        David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).IndividualHops.( LimbID{a} ).Ankle.Sagittal.Angle_NonTruncated.( HoppingRate_ID{b} ).( HoppingTrialNumber{ p } );

                                    

%% Pull Out Indexing Data from Data Structure                                    
                                    




                                %Pull out FirstDataPointofSthHop from
                                % the data structure. This is
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

                                %Pull out the frame numbers for the beginning of flight pahse, relative
                                %to entire trial
                                BeginFlight_FrameNumbers =  IndexingIntoData_HoppingRateB_DataStructure.EndGroundContact_forFlightPhase_EMGFrames;
                                
                                
                                
                                %Pull out the length of the flight phase, in EMG Sampling Hz
                                LengthofFlightPhase_Truncated_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofFlightPhase_Truncated_EMGSamplingHz;

                                %Pull out the length of the flight phase, in EMG Sampling Hz
                                LengthofFlightPhase_NonTruncated_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofFlightPhase_NonTruncated_EMGSamplingHz;
                                
                                %Pull out the length of the ground contact phase, in EMG Sampling Hz
                                LengthofContactPhase_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofContactPhase_EMGSamplingHz;
                                
                                %Pull out the length of the entire hop cycle, in EMG Sampling Hz
                                LengthofEntireHopCycle_NonTruncated_EMGSamplingHz = IndexingIntoData_HoppingRateB_DataStructure.LengthofEntireHopCycle_NonTruncated_EMGSamplingHz;

                                

                                %Find the minimum length of the flight phase for the Qth trial of 10 hops
                                MinLengthofFlightPhase_EMGSamplingHz = min(LengthofFlightPhase_Truncated_EMGSamplingHz(:,p));


                                %Find the frame of minimum L5-S1 position, in EMG Samp Hz
                                FrameofBrakingPhaseEnd_EMGSampHz = IndexingIntoData_HoppingRateB_DataStructure.FrameofMinL5S1Position_EndBraking_EMGSampHz;


                                %Find the frame of minimum L5-S1 position, in EMG Samp Hz
                                FrameofPropulsionPhaseBegin_EMGSampHz = IndexingIntoData_HoppingRateB_DataStructure.FrameofMinL5S1Position_BeginPropulsion_EMGSampHz;
    




                                %Pull out the indices for the first frame of the ground contact
                                %phase, in terms of EMG sampling Hz
                                GContactBegin_MoCapFrameNumbers = IndexingIntoData_HoppingRateB_DataStructure.BeginGroundContact_MoCapFrames;

                                %Pull out the Frames for the last frame of the ground contact
                                %phase, in terms of EMG sampling Hz
                                GContactEnd_MoCapFrameNumbers = IndexingIntoData_HoppingRateB_DataStructure.EndGroundContact_forContactPhase_MoCapFrames;

                                %Pull out the frame numbers for the beginning of flight pahse, relative
                                %to entire trial
                                BeginFlight_MoCapFrameNumbers =  IndexingIntoData_HoppingRateB_DataStructure.EndGroundContact_forFlightPhase_MoCapFrames;




                                % %Index into data structure to pull out the onset and offset information IF we
                                % %decided not to reprocess pre-activation for this particular muscle
                                % if  strcmp( cell2mat( ReprocessPreactivation_Cell ), 'No' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'N' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'no' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'n' ) 
                                % 
                                %     FrameNumber_OnsetBeforeGContactBegin_EntireTrial = ...
                                %         David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).( 'IndividualHops' ).( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).( 'PreactivationOnsetFrame_Relative2EntireTrial_OnlyFlightPhase' );
                                % 
                                %     FrameofMuscleOffset_EntireTrial_EMGSampHz = ...
                                %         David_DissertationEMGDataStructure.Post_Quals.( GroupList{ m } ).( ParticipantList{ n } ).( 'IndividualHops' ).( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).( 'MuscleOffsetFrame_Relative2EntireTrial_NonTruncated' );
                                % 
                                % end



    %% Initialize Variables within P Loop.     
    


                                    MuscleQ_Normalized_10HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_10HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_10HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_10HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_DoublePassSmoothed_10HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_10HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_10HzBandpass_IndividualHops_Downsampled = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_10HzBandpass_IndividualHops_Downsampled = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_10HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_DoublePassLE_10HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_RectifiedEMG_10HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_SmoothedEMG_10HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_DoublePassLE_10HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_NormalizedEMG_10HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    %Initialize variable to hold EMG data for individual hops
                                    MuscleQ_Normalized_30HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_30HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_30HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_30HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_DoublePassSmoothed_30HzBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_30HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_30HzBandpass_IndividualHops_Downsampled = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_30HzBandpass_IndividualHops_Downsampled = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_30HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_DoublePassLE_30HzBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_DoublePassLE_30HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_NormalizedEMG_30HzBandpass_IndividualHops_NonTruncated = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    MuscleQ_Rectified_NoBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_NoBandpass_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_NoBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_NoBandpass_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_NoBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_NoBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified_NoBandpass_OnsettoOffset = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_NoBandpass_OnsettoOffset = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    MuscleQ_Highpassed4Coherence_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified4Coherence_IndividualHops = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified4Coherence_IndividualHops_ContactPhase = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Highpassed4Coherence_IndividualHops_ContactPhase =  NaN(5, numel(GContactBegin_FrameNumbers(:,p)));


                                    %Initialize variables to hold EMG time series - beginning = muscle
                                    %onset, end = end of ground contact phase
                                    MuscleQ_Rectified_10HzBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_10HzBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_10HzBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    MuscleQ_Rectified_30HzBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_30HzBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_30HzBandpass_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    MuscleQ_Rectified4Coherence_OnsettoGContactEnd = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));


                                    %Initialize variables to hold EMG time series - beginning = muscle
                                    %onset, end = muscle offset
                                    MuscleQ_Rectified_10HzBandpass_OnsettoOffset = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Rectified4Coherence_OnsettoOffset = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_10HzBandpass_OnsettoOffset = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_10HzBandpass_OnsettoOffset= NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    MuscleQ_Rectified_30HzBandpass_OnsettoOffset = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Smoothed_30HzBandpass_OnsettoOffset = NaN(5, numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_Normalized_30HzBandpass_OnsettoOffset= NaN(5, numel(GContactBegin_FrameNumbers(:,p)));

                                    %Initialize variables to hold the number of data frames in each hop
                                    NumEl_SthHop_MoCap = NaN(4,1);
                                    NumEl_SthHop_EMG = NaN(4,1);

                                    %Initialize variables to hold data relevant for determining muscle
                                    %pre-activation onset, using the entire hop rather than just flight
                                    %phase
                                    FrameNumber_MaxDifferencefromReferenceLine_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MaxDifferencefromReferenceLine_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2 = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameNumber_OnsetBeforeGContactBegin_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameNumber_OnsetBeforeGContactBegin_EntireHop_Method2 = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_OnsetBeforeGContactBegin_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_OnsetBeforeGContactBegin_EntireHop_Method2 = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables for determining muscle pre-activation onset,
                                    %using the standard deviation threshold method. First submethod is
                                    %using the resting EMG to find the threshold
                                    OnsetFrame_SDThreshold_RestingEMG = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Frame_OnsetB4GContact_SDThreshold_RestingEMG_EntireTrial = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Frame_OnsetB4Contact_SDThreshold_RestingEMG_IndividualHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Time_OnsetB4Contact_SDThreshold_RestEMG_EntireTrial = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Same as above, but threshold is determined using the baseline from
                                    %each individual hop
                                    OnsetFrame_SDThreshold_EachHopBaseline = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Frame_OnsetB4GContact_SDThreshold_EachHopBaseline_EntireTrial = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Frame_OnsetB4Contact_SDThreshold_EachHopBaseline_IndividualHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    Time_OnsetB4Contact_SDThreshold_BaselinePerHop_EntireTrial = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);


                                    %Initialize variables to hold data relevant for determining muscle
                                    %pre-activation onset, using just flight phase rather than the entire hop
                                    FrameNumber_MaxDifferencefromReferenceLine_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MaxDifferencefromReferenceLine_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameNumber_OnsetBeforeGContactBegin_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameNumber_OnsetBeforeGContactBegin_EntireTrial = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_OnsetBeforeGContactBegin_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_OnsetBeforeGContactBegin_EntireTrial = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);


                                    %Initialize variables to hold data relevant for determining muscle
                                    %offset during flight phase
                                    FrameofMuscleOffset_FlightPhase_EMGSampHz = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimeofMuscleOffset_FlightPhase = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_Offset_FlightPhase = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameNumber_MinDifferencefromReferenceLine_FlightMuscleOffset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MinDifferencefromReferenceLine_FlightMuscleOffset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);


                                    %Initialize variables to hold data relevant for determining muscle
                                    %offset during flight phase - this is a second method for determining
                                    %offset. Requires EMG to decrease for 25 ms
                                    TimeofMuscleOffset_FlightPhase_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofMuscleOffset_FlightPhase_EMGSampHz_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_FlightMuscleOffset_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold data relevant for determining muscle
                                    %offset - only use data after muscle onset
                                    FrameofMuscleOffset_AfterOnset_EMGSampHz = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimeofMuscleOffset_AfterOnset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold data relevant for determining muscle
                                    %offset - use data from the entire hop, not just after muscle onset
                                    FrameofMuscleOffset_EntireHop_EMGSampHz = NaN(numel(GContactBegin_FrameNumbers(:,p)), 1);
                                    TimeofMuscleOffset_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_Offset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold frame and time of muscle offset, from
                                    %muscle onset to end of ground contact phase
                                    FrameNumber_MinDifferencefromReferenceLine_MuscleOffset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MinDifferencefromReferenceLine_MuscleOffset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold frame and time of muscle offset, from
                                    %muscle onset to end of ground contact phase. This is a second method
                                    %for determining offset - requires EMG to decrease for 25 ms
                                    TimeofMuscleOffset_AfterOnset_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofMuscleOffset_AfterOnset_EMGSampHz_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimePoint_MuscleOffsetAfterOnset_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold time and frame of muscle offset, when
                                    %using the entire hop. This is a second method
                                    %for determining offset - requires EMG to decrease for 25 ms
                                    TimeofMuscleOffset_EntireHop_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    TimeofMuscleOffset_EntireTrial = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofMuscleOffset_EntireHop_EMGSampHz_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofMuscleOffset_EntireTrial_EMGSampHz = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                     %Initialize variables to hold time and frame of muscle offset, relative to the entire trial (EMG not segmented into individual hops). This is a second method
                                    %for determining offset - requires EMG to decrease for 25 ms
                                    TimeofMuscleOffset_EntireTrial_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofMuscleOffset_EntireTrial_EMGSampHz_DoubleCheck = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);


                                    %Initialize variable to hold number of data frames in integrated EMG
                                    %signal, using flight phase only
                                    NumEl_SthHop_IntegratedEMG_FlightOnly = NaN(numel(GContactBegin_FrameNumbers(:,p)),1); 

                                    %Initialize variable to hold integrated EMG for various signals -
                                    %flight phase EMG only, EMG from entire hop, EMG from muscle onset to
                                    %end of ground contact, and if muscle deactivates during flight phase
                                    MuscleQ_IntegratedEMG_FlightOnly = NaN(1,numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_IntegratedEMG_EntireHop = NaN(1,numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_IntegratedEMG_MuscleOffset = NaN(1,numel(GContactBegin_FrameNumbers(:,p)));
                                    MuscleQ_IntegratedEMG_FlightMuscleOffset = NaN(1,numel(GContactBegin_FrameNumbers(:,p)));

                                    %Initialize variables to hold data relevant for determining if there
                                    %is a second period of muscle activation before the end of ground
                                    %contact
                                     TimePoint_SecondOnsetToGContactEnd = NaN(numel(GContactBegin_FrameNumbers(:,p)),1); 
                                     FrameNumber_SecondOnsetToGContactEnd_EntireHop = NaN(numel(GContactBegin_FrameNumbers(:,p)),1); 
                                     TimePoint_MaxDifferencefromReferenceLine_OffsetToGContactEnd = NaN(numel(GContactBegin_FrameNumbers(:,p)),1); 
                                     FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd = NaN(numel(GContactBegin_FrameNumbers(:,p)),1); 


                                     %Initialize varible to hold integrated EMG for the second period of
                                     %muscle activation, if there is one.
                                     MuscleQ_IntegratedEMG_Offset1ToGContactEnd = NaN(numel(GContactBegin_FrameNumbers(:,p)),1); 

                                     %Initialize variable to hold length of hop after downsampling the
                                     %EMG to match the MoCap data length
                                    DownsampledLength_ofHopS = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variable to hold the number of data frames from muscle
                                    %onset to offset
                                    NumberofFrames_OnsettoOffset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold the first frame of ground contact and
                                    %the length of the ground contact phase, considering only the period
                                    %of time when the muscle is active
                                    FrameofGContactBegin_Onset2Offset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    LengthofGroundContactPhase_Onset2Offset_Frames = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold the frame at which braking phase begins
                                    %and ends and length of braking phase, considering only the period of
                                    %time when the muscle is active
                                    LengthofBrakingPhase_Onset2Offset_Frames = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofBrakingPhaseBegin_Onset2Offset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofBrakingPhaseEnd_Onset2Offset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);

                                    %Initialize variables to hold the frame at which propulsion phase begins
                                    %and ends and length of propulsion phase, considering only the period of
                                    %time when the muscle is active
                                    LengthofPropulsionPhase_Onset2Offset_Frames = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofPropulsionPhaseBegin_Onset2Offset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                    FrameofPropulsionPhaseEnd_Onset2Offset = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);


                                    %Initialize variable to hold time of maximum difference from
                                    %reference line - this is the time of pre-activation onset
                                     TimePoint_MaxDifferencefromRefLine_FlightOnly_ForPlotting = NaN(numel(GContactBegin_FrameNumbers(:,p)),1);
                                
                                    %Initialize variables for recreatingplots
                                    f3 = [];
                                    f2 = [];
                                    f7 = [];
                                    f1 = [];
                                    f10 = [];
                                    f11 = [];
                                    f12 = [];
                                    f99 = [];
                                    



        %% Remove DC Offset

                                    %Subtract mean of resting EMG from raw EMG to remove DC offset
                                    MuscleQ_DCOffsetRemoved = MuscleQTrialP - MuscleQ_RestingEMGMean;

                                    %Create a time vector to be used for the x-axis of plots
                                    TimeVector = (1:numel(MuscleQ_DCOffsetRemoved))./ EMGSampHz;

                                    %Only show the figure below if we told the code to show all figures
                                    %for Participant N
                                    if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )
                                    
                                        %Plot the EMG with and without DC offset to check the quality of the
                                        %removal
                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of DC Offset Removal ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p} ])
                                        X1 = subplot(2,1,1);
                                        plot(TimeVector',MuscleQTrialP,'LineWidth',1.5,'Color','#0072BD')
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Raw EMG - with DC Offset')

                                        X2 = subplot(2,1,2);
                                        plot(TimeVector',MuscleQ_DCOffsetRemoved,'LineWidth',1.5,'Color','#7E2F8E')
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Raw EMG - DC Offset Removed')

                                        linkaxes( [ X1 X2 ], 'xy')

                                        pause
                                        
                                         %End the If statement - whether to show the plot for Participant N   
                                    end
                                     
                                    
                                    

%% Pad Data for Filtering

                                %When padding, will split data in half - pad the front with
                                %half, pad the back with half
                                HalfLengthofData_forPadding = round( numel( MuscleQ_DCOffsetRemoved ) ./ 2 );
                                
                                %Reverse the data - first value is now last, last value is now
                                %first
                                InvertedData = flip( MuscleQ_DCOffsetRemoved );
                                
                                %Divide the inverted data into halves. First half = the first
                                %half of the original data, but reversed from front to back.
                                %Same for second half
                                FirstHalfofInvertedData = InvertedData(  HalfLengthofData_forPadding : end ); 
                                SecondHalfofInvertedData = InvertedData( 1 : HalfLengthofData_forPadding ) ;
    
                                %Avoid any artificial noise. Subtract the first half of the inverted data from the very first value of
                                %the original data. Subtract the second half of the inverted
                                %data from the last value of the original data.
                                CorrectedFirstHalfofInvertedData = FirstHalfofInvertedData(end) - FirstHalfofInvertedData;
                                CorrectedSecondHalfofInvertedData = SecondHalfofInvertedData(1) - SecondHalfofInvertedData;
                               
                                %Add inverted data to original data
                                PaddedData = [ CorrectedFirstHalfofInvertedData; MuscleQ_DCOffsetRemoved; CorrectedSecondHalfofInvertedData];
                                
                                %Will need to segment original data back out from padded data.
                                OriginalDataIndices = (HalfLengthofData_forPadding +1 ) :  (HalfLengthofData_forPadding + numel( MuscleQ_DCOffsetRemoved ) );




%% Check Padding of Data


                                %Create a time vector to be used for the x-axis of plots
                                TimeVector_PaddedData = ( 1 : numel( PaddedData ) )./EMGSampHz;
    
                                %Only show plots if we told the code to do so
                                if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )
    
                                    %Plot the EMG with and without DC offset to check the quality of the
                                    %removal
                                    figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Padding of Data ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{ a}, '  ', HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p}] )
                                    X1 =  subplot(2,1,1);
                                    plot(TimeVector', MuscleQ_DCOffsetRemoved, 'LineWidth',2)
                                    xlabel('Time (s)')
                                    ylabel( RawHoppingUnits_string )
                                    title('Raw MVIC - DC Offset Removed')
        
                                    subplot(2,1,2)
                                    X2 = plot( TimeVector_PaddedData', PaddedData, 'LineWidth',2);
                                    xlabel('Time (s)')
                                    ylabel( RawHoppingUnits_string )
                                    title('Padded Raw MVIC - DC Offset Removed')
        
                                    %Link the axes so any zooming in/out in one plot changes the other plot
                                    linkaxes( [ X1 X2 ], 'xy')
        
                                    pause
    
                                end



%% Notch Filter

                                %Use a notch-filter set to filter out any 60 Hz noise from equipment
                                MuscleQ_NotchFilteredAt60Hz = BasicFilter( PaddedData, EMGSampHz,60,2,'notch');

                                %Notch filter at 50 Hz
                                MuscleQ_NotchFilteredAt50Hz = BasicFilter(MuscleQ_NotchFilteredAt60Hz,1500,50,2,'notch');

                                %David_DissertationEMGDataStructure = setfield(David_DissertationEMGDataStructure,'PilotDataforQuals',GroupList{m}, ParticipantList{n},'HoppingKinematicsKinetics','IndividualHops','RightLimb',...
                                    %'GasMed_MTU','BeginGroundContact_GRFFrames',RLimb_GContactBegin_FrameNumbers_GRFHz);



%% Bandpass Filter

                                    %Bandpass filter with low-pass cut off of 500 Hz and high-pass
                                    %cut-off of 10 Hz, 2nd order
                                    MuscleQ_BandpassFiltered_10Hz = BasicFilter( PaddedData,1500,[10 500], 2, 'bandpass');

                                    %Bandpass filter with low-pass cut off of 500 Hz and high-pass
                                    %cut-off of 10 Hz, 2nd order
                                    MuscleQ_BandpassFiltered_30Hz = BasicFilter( PaddedData,1500,[30 500], 2, 'bandpass');
                                     
                                    
                                    

%% High pass filter the bandpass filtered
       
                                    %Highpass filter the bandpass filtered data. Will need for this coherence analysis. Use a 4th order high-pass filterwith low-pass cut off of 250 Hz
                                    MuscleQ_Highpassed4Coherence = BasicFilter( MuscleQ_BandpassFiltered_10Hz, 1500, 250, 2, 'highpass');
                                    

                                    
%% Rectify Hopping EMG - 10 Hz Bandpass                       


                                    %Set MuscleQ_Rectified to be the same as
                                    %MuscleQ_BandPassFiltered. We will overwrite this later
                                    MuscleQ_Rectified_10HzBandpass = MuscleQ_BandpassFiltered_10Hz;

                                    %Find all negative values in MuscleQ_BandpassFiltered
                                    MuscleQ_NegativeValues_10HzBandpass = MuscleQ_BandpassFiltered_10Hz < 0;

                                    %Multiply all negative values in MuscleQ_Rectified by -1 so that
                                    %all values are now positive
                                    MuscleQ_Rectified_10HzBandpass(MuscleQ_NegativeValues_10HzBandpass) = MuscleQ_Rectified_10HzBandpass(MuscleQ_NegativeValues_10HzBandpass)*(-1);

                                    
                                    %Set MuscleQ_Rectified_forCoherence to be the same as
                                    %MuscleQ_Highpassed4Coherence. We will overwrite this later
                                    MuscleQ_Rectified_forCoherence = MuscleQ_Highpassed4Coherence;
                                    
                                    %Find all negative values in MuscleQ_BandpassFiltered
                                    MuscleQ_NegativeValues_forCoherence = MuscleQ_Highpassed4Coherence < 0;
                                    
                                    %Multiply all negative values in MuscleQ_Rectified_forCoherence by -1 so that
                                    %all values are now positive
                                    MuscleQ_Rectified_forCoherence(MuscleQ_NegativeValues_forCoherence) =...
                                        MuscleQ_Rectified_forCoherence( MuscleQ_NegativeValues_forCoherence )*(-1);
                                    
                                    

%% Rectify Hopping EMG - 30 Hz Bandpass     

                                    %Set MuscleQ_Rectified to be the same as
                                    %MuscleQ_BandPassFiltered. We will overwrite this later
                                    MuscleQ_Rectified_30HzBandpass = MuscleQ_BandpassFiltered_30Hz;

                                    %Find all negative values in MuscleQ_BandpassFiltered
                                    MuscleQ_NegativeValues_30HzBandpass = MuscleQ_BandpassFiltered_30Hz < 0;

                                    %Multiply all negative values in MuscleQ_Rectified by -1 so that
                                    %all values are now positive
                                    MuscleQ_Rectified_30HzBandpass(MuscleQ_NegativeValues_30HzBandpass) = MuscleQ_Rectified_30HzBandpass(MuscleQ_NegativeValues_30HzBandpass)*(-1);
                             

%% Rectify Hopping EMG - No Bandpass

                                    %Rectify the non-bandpass filtered data to compare with Eugene's
                                    %results

                                    %Set MuscleQ_Rectified to be the same as
                                    %MuscleQ_BandPassFiltered. We will overwrite this later
                                    MuscleQ_Rectified_NoBandpass = MuscleQ_DCOffsetRemoved;

                                    %Find all negative values in MuscleQ_BandpassFiltered
                                    MuscleQ_NegativeValues_NoBandpass = MuscleQ_DCOffsetRemoved < 0;

                                    %Multiply all negative values in MuscleQ_Rectified by -1 so that
                                    %all values are now positive
                                    MuscleQ_Rectified_NoBandpass(MuscleQ_NegativeValues_NoBandpass) = MuscleQ_Rectified_NoBandpass(MuscleQ_NegativeValues_NoBandpass)*(-1);

                                    
                                    
%% Linear Envelope Hopping EMG                       

                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 3.5 Hz
                                    MuscleQ_Smoothed_10HzBandpass = BasicFilter_SinglePass(MuscleQ_Rectified_10HzBandpass,1500, 3.5, 2,'lowpass');

                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 4.5 Hz
                                    MuscleQ_DoublePassSmoothed_10HzBandpass = BasicFilter(MuscleQ_Rectified_10HzBandpass,1500, 4.5, 2,'lowpass');


                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 3.5 Hz
                                    MuscleQ_Smoothed_30HzBandpass = BasicFilter_SinglePass(MuscleQ_Rectified_30HzBandpass,1500, 3.5, 2,'lowpass');

                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 4.5 Hz
                                    MuscleQ_DoublePassSmoothed_30HzBandpass = BasicFilter(MuscleQ_Rectified_30HzBandpass,1500, 4.5, 2,'lowpass');

                                    

                                    
         %% Normalize Hopping EMG                           

                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_Normalized_10HzBandpass = (MuscleQ_Smoothed_10HzBandpass./MuscleQ_MVIC_Value).*100;

                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_DoublePassNormalized_10HzBandpass = (MuscleQ_DoublePassSmoothed_10HzBandpass./MuscleQ_MVIC_Value).*100;



                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_Normalized_30HzBandpass = (MuscleQ_Smoothed_30HzBandpass./MuscleQ_MVIC_Value).*100;

                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_DoublePassNormalized_30HzBandpass = (MuscleQ_DoublePassSmoothed_30HzBandpass./MuscleQ_MVIC_Value).*100;


                                    %Normalize the non-bandpassed data
                                    MuscleQ_Normalized_NoBandpass = ( MuscleQ_Rectified_NoBandpass ./ MuscleQ_MVIC_Value_RectifiedNoBandpass).*100;
                                    


%% Remove Padding

                        MuscleQ_BandpassFiltered_10Hz_Padded = MuscleQ_BandpassFiltered_10Hz;
                        MuscleQ_Rectified_10HzBandpass_Padded = MuscleQ_Rectified_10HzBandpass;
                        MuscleQ_Smoothed_10HzBandpass_Padded = MuscleQ_Smoothed_10HzBandpass;
                        MuscleQ_DoublePassSmoothed_10HzBandpass_Padded = MuscleQ_DoublePassSmoothed_10HzBandpass;
                        MuscleQ_Normalized_10HzBandpass_Padded = MuscleQ_Normalized_10HzBandpass;
                        MuscleQ_DoublePassNormalized_10HzBandpass_Padded = MuscleQ_DoublePassNormalized_10HzBandpass;

                        MuscleQ_BandpassFiltered_30Hz_Padded = MuscleQ_BandpassFiltered_30Hz;
                        MuscleQ_Rectified_30HzBandpass_Padded = MuscleQ_Rectified_30HzBandpass;
                        MuscleQ_Smoothed_30HzBandpass_Padded = MuscleQ_Smoothed_30HzBandpass;
                        MuscleQ_DoublePassSmoothed_30HzBandpass_Padded = MuscleQ_DoublePassSmoothed_30HzBandpass;
                        MuscleQ_Normalized_30HzBandpass_Padded = MuscleQ_Normalized_30HzBandpass;
                        MuscleQ_DoublePassNormalized_30HzBandpass_Padded = MuscleQ_DoublePassNormalized_30HzBandpass;


                        MuscleQ_NotchFilteredAt60Hz = MuscleQ_NotchFilteredAt60Hz( OriginalDataIndices );
                        MuscleQ_NotchFilteredAt50Hz = MuscleQ_NotchFilteredAt50Hz( OriginalDataIndices );
                        MuscleQ_BandpassFiltered_10Hz = MuscleQ_BandpassFiltered_10Hz( OriginalDataIndices );
                        MuscleQ_Smoothed_10HzBandpass = MuscleQ_Smoothed_10HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassSmoothed_10HzBandpass = MuscleQ_DoublePassSmoothed_10HzBandpass( OriginalDataIndices );
                        MuscleQ_Rectified_10HzBandpass = MuscleQ_Rectified_10HzBandpass( OriginalDataIndices );
                        MuscleQ_Normalized_10HzBandpass = MuscleQ_Normalized_10HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassNormalized_10HzBandpass = MuscleQ_DoublePassNormalized_10HzBandpass( OriginalDataIndices );
                        
                        MuscleQ_BandpassFiltered_30Hz = MuscleQ_BandpassFiltered_30Hz( OriginalDataIndices );
                        MuscleQ_Smoothed_30HzBandpass = MuscleQ_Smoothed_30HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassSmoothed_30HzBandpass = MuscleQ_DoublePassSmoothed_30HzBandpass( OriginalDataIndices );
                        MuscleQ_Rectified_30HzBandpass = MuscleQ_Rectified_30HzBandpass( OriginalDataIndices );
                        MuscleQ_Normalized_30HzBandpass = MuscleQ_Normalized_30HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassNormalized_30HzBandpass = MuscleQ_DoublePassNormalized_30HzBandpass( OriginalDataIndices );
                        MuscleQ_Highpassed4Coherence = MuscleQ_Highpassed4Coherence( OriginalDataIndices );
                        MuscleQ_Rectified_forCoherence = MuscleQ_Rectified_forCoherence( OriginalDataIndices );


                        
%Only show plots if we told the code to do so
                        if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                            %Plot the EMG before and after smoothing to check the quality of the
                            %smoothjing
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Padding Removal ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{ a}, '  ',  MuscleID{q}, ' _ ' HoppingRate_ID{ b } ] )

                            subplot( 3, 1, 1 )
                            plot(TimeVector_PaddedData',MuscleQ_Rectified_10HzBandpass_Padded,'LineWidth',1.5)
                            hold on
                            plot(TimeVector_PaddedData',MuscleQ_Smoothed_10HzBandpass_Padded,'LineWidth',4)
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title(['Padded and Smoothed Data ', ParticipantList{n}, ' ', LimbID{ a}, ' _ ' HoppingRate_ID{ b } ] )
                            legend('MVIC Rectified','MVIC Smoothed');
                            hold off

                            subplot( 3, 1, 2 )
                            plot(TimeVector', MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5)
                            hold on
                            plot(TimeVector', MuscleQ_Smoothed_10HzBandpass,'LineWidth',4)
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title(['Rectified/Smoothed Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{ a}, ' _ ' HoppingRate_ID{ b } ] )
                            legend('MVIC Rectified','MVIC Smoothed');
                            hold off
                            hold off

%                             subplot( 6, 1, 3 )
%                             plot(TimeVector', MuscleQ_Normalized,'LineWidth',1.5)
%                             xlabel('Time (s)')
%                             ylabel( RawHoppingUnits_string )
%                             title(['Normalized Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{ a}, ' _ ' HoppingRate_ID{ b } ] )
%                             legend('MVIC Rectified','MVIC Smoothed');
%                             hold off

                            subplot( 3, 1, 3 )
                            plot(TimeVector', MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5)
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title(['Bandpassed Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{ a}, ' _ ' HoppingRate_ID{ b } ] )
                            hold off


                            pause



%% Plot Filtered Data


                        
                            %Plot the EMG before and after  filtering to check the quality of the
                            %filtering
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Filtering ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            X1 = subplot(5,1,1);
                            plot(TimeVector',MuscleQ_DCOffsetRemoved,'LineWidth',1.5,'Color','#0072BD')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Raw EMG - DC Offset Removed')

                            X2 = subplot(5,1,2);
                            plot(TimeVector',MuscleQ_NotchFilteredAt60Hz,'LineWidth',1.5,'Color','#77AC30')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Notch Filtered @ 60 Hz')

                            X3 = subplot(5,1,3);
                            plot(TimeVector',MuscleQ_NotchFilteredAt50Hz,'LineWidth',1.5,'Color','#D95319')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Notch Filtered @ 50 Hz')

                            X4 = subplot(5,1,4);
                            plot(TimeVector',MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Bandpass Filtered - 10 Hz')

                            X5 = subplot(5,1,5);
                            plot(TimeVector',MuscleQ_BandpassFiltered_30Hz,'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Bandpass Filtered - 30 Hz')

                            %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [X1 X2 X3 X4 X5], 'xy')

                            savefig( [ ParticipantList{ n }, '_', 'Check Quality of Filtering', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                            pause
                            

%% Plot High-Pass Filtered Data

                        
                             %Plot the EMG before and after high-pass filtering (for coherence) to check the quality of the
                            %filtering
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of High-pass Filtering for Coherence ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            X1 = subplot(2,1,1);
                            plot(TimeVector',MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5,'Color','#0072BD')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Bandpass Filtered')

                            X2 = subplot(2,1,2);
                            plot(TimeVector',MuscleQ_Highpassed4Coherence,'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG High-pass Filtered for Coherence')

                            %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [ X1 X2 ], 'xy')

                            pause



%% Plot Rectified Data - 10 Hz Bandpass
                        

                        
                            %Plot the EMG before and after rectification to check the quality of the
                            %rectification - NOT for coherence
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Rectification - 10 Hz Bandpass Filter ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            X1 = subplot(4,1,1);
                            plot(TimeVector',MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5,'Color','#0072BD')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Bandpass Filtered - 10 Hz')

                            X2 = subplot(4,1,2);
                            plot(TimeVector',MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Rectified - 10 Hz Bandpass Filter')



                        
                            %Plot the EMG before and after rectification to check the quality of the
                            %rectification - NOT for coherence - 30 Hz Bandpass
                            X3 = subplot(4,1,3);
                            plot(TimeVector',MuscleQ_BandpassFiltered_30Hz,'LineWidth',1.5,'Color','#0072BD')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Bandpass Filtered - 30 Hz')

                            X4 = subplot(4,1,4);
                            plot(TimeVector',MuscleQ_Rectified_30HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Rectified - 30 Hz Bandpass Filter')

                            %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [ X1 X2 X3 X4 ], 'xy')

                            savefig( [ ParticipantList{ n }, '_', 'Check Rectification', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                            pause





%% Plot GRF and Rectified EMG

                            %Create a time vector for the GRF to use in creating plots
                            TimeVector_GRF = (1: numel(vGRFTrialP) )./GRFSampHz;

                            %Plot the Rectified EMG with vGRF
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Compare EMG with vGRF ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            X1 = subplot( 3, 1, 1 );
                            plot(TimeVector_GRF',vGRFTrialP,'LineWidth',1.5,'Color','#0072BD')
                            xlabel('Time (s)')
                            ylabel('Vertical GRF (N)')
                            title('vGRF')

                            X2 = subplot( 3, 1, 2 );
                            plot(TimeVector',MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Rectified - 10 Hz Bandpass Filter')

                            X3 = subplot( 3, 1, 3 );
                            plot(TimeVector',MuscleQ_Rectified_30HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Rectified - 30 Hz Bandpass Filter')

                            %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [ X1 X2 X3], 'x')

                            savefig( [ ParticipantList{ n }, '_', 'Compare EMG with vGRF', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                            pause



%% Plot Rectified EMG For Coherence

                            %Plot the EMG before and after rectification to check the quality of the
                            %rectification - FOR coherence
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Rectification for Coherence ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            X1 = subplot(2,1,1);
                            plot(TimeVector', MuscleQ_Highpassed4Coherence, 'LineWidth',1.5,'Color','#0072BD')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Highpass Filtered for Coherence')

                            X2 = subplot(2,1,2);
                            plot(TimeVector', MuscleQ_Rectified_forCoherence, 'LineWidth',1.5,'Color','#7E2F8E')
                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Rectified for Coherence')

                            %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [ X1 X2 ], 'xy')

                            pause
                            
                            




%% Plot Linear Enveloped Data
                        
                            %Plot the EMG before and after smoothing to check the quality of the
                            %smoothing
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Smoothing ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            sgtitle( ['Check Quality of Smoothing ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p} ] , 'FontSize', 20 )
                            X1 = subplot( 2, 1, 1 );
                            plot(TimeVector',MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5,'Color','#0072BD')
                            hold on
                            plot(TimeVector',MuscleQ_Smoothed_10HzBandpass,'LineWidth',4)
                            plot(TimeVector',MuscleQ_DoublePassSmoothed_10HzBandpass,'LineWidth',1)

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            %Create a horizontal line at -10. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to magenta
                            L2 = line( [min( TimeVector ), max( TimeVector ) ], [ -10, -10 ] );
                            L2.LineWidth = 2;
                            L2.Color = 'm';

                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title(['Check Quality of Smoothing - 10 Hz Bandpass Filter', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            legend('Hopping EMG Rectified - 10 Hz Bandpass Filter','Single Pass Filter - 3.5 Hz Cutoff', 'Double Pass Filter - 4.5 Hz Cutoff');
                            hold off




                            % Plot Linear Enveloped Data - 30 Hz Bandpass
                        
                            %Plot the EMG before and after smoothing to check the quality of the
                            %smoothing
                            X2 = subplot( 2, 1, 2);
                            plot(TimeVector',MuscleQ_Rectified_30HzBandpass,'LineWidth',1.5,'Color','#0072BD')
                            hold on
                            plot(TimeVector',MuscleQ_Smoothed_30HzBandpass,'LineWidth',4)
                            plot(TimeVector',MuscleQ_DoublePassSmoothed_30HzBandpass,'LineWidth',1)

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            %Create a horizontal line at -10. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to magenta
                            L2 = line( [min( TimeVector ), max( TimeVector ) ], [ -10, -10 ] );
                            L2.LineWidth = 2;
                            L2.Color = 'm';

                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title(['Check Quality of Smoothing - 30 Hz Bandpass Filter', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            legend('Hopping EMG Rectified - 30 Hz Bandpass Filter','Single Pass Filter - 3.5 Hz Cutoff', 'Double Pass Filter - 4.5 Hz Cutoff');
                            hold off

                            %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [ X1 X2 ], 'xy')


                            savefig( [ ParticipantList{ n }, '_', 'Check Quality of Smoothing', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                            pause




%% Plot Normalized Data 
                        
                            %Plot the EMG before and after normalization to check the quality of the
                            %normalization
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Normalization ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            X1 = subplot(4,1,1);
                            plot(TimeVector',MuscleQ_Smoothed_10HzBandpass,'LineWidth',2,'Color','#0072BD')
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Smoothed - 10 Hz Bandpass Filter')
                            hold off

                            subplot(4,1,2)
                            X2 = plot(TimeVector',MuscleQ_Normalized_10HzBandpass,'LineWidth',2,'Color','#7E2F8E');
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel('Normalized (%RC)')
                            title('Hopping EMG Normalized to Reference Contraction (Max Height Single-leg Vertical Jump) - 10 Hz Bandpass Filter')
                            hold off




                            % Plot Normalized Data - 30 Hz Bandpass
                        
                            %Plot the EMG before and after normalization to check the quality of the
                            %normalization
                            X3 = subplot(4,1,3);
                            plot(TimeVector',MuscleQ_Smoothed_30HzBandpass,'LineWidth',2,'Color','#0072BD')
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Smoothed - 30 Hz Bandpass Filter')
                            hold off

                            subplot(4,1,4)
                            X4 = plot(TimeVector',MuscleQ_Normalized_30HzBandpass,'LineWidth',2,'Color','#7E2F8E');
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel('Normalized (%RC)')
                            title('Hopping EMG Normalized to Reference Contraction (Max Height Single-leg Vertical Jump) - 30 Hz Bandpass Filter')
                            hold off

                             %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [ X1 X2 X3 X4 ], 'xy')

                            savefig( [ ParticipantList{ n }, '_', 'Check Quality of Normalization', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                            pause


%% Plot Normalized Data - 30 Hz Bandpass vs No Bandpass

                        
                            %Plot the EMG before and after normalization to check the quality of the
                            %normalization
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Normalization - 30 Hz Bandpass vs No Bandpass ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b}, '_' ,HoppingTrialNumber{p}])
                            X1 = subplot(4,1,1);
                            plot(TimeVector',MuscleQ_Smoothed_30HzBandpass,'LineWidth',2,'Color','#0072BD')
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Smoothed - 30 Hz Bandpass Filter')
                            hold off

                            subplot(4,1,2)
                            X2 = plot(TimeVector',MuscleQ_Normalized_30HzBandpass,'LineWidth',2,'Color','#7E2F8E');
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel('Normalized (%RC)')
                            title('Hopping EMG Normalized to Reference Contraction (Max Height Single-leg Vertical Jump) - 30 Hz Bandpass Filter')
                            hold off




                            % Plot Normalized Data - 30 Hz Bandpass
                        
                            %Plot the EMG before and after normalization to check the quality of the
                            %normalization
                            X3 = subplot(4,1,3);
                            plot(TimeVector',MuscleQ_Rectified_NoBandpass,'LineWidth',2,'Color','#0072BD')
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel( RawHoppingUnits_string )
                            title('Hopping EMG Rectified - No Bandpass Filter')
                            hold off

                            subplot(4,1,4)
                            X4 = plot(TimeVector',MuscleQ_Normalized_NoBandpass,'LineWidth',2,'Color','#7E2F8E');
                            hold on

                            %Create a horizontal line at 0. Make it extend the entire time series length
                            %via min( TimeVector ) and max (TimeVector). Change size to 2
                            %and color to black
                            L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                            L.LineWidth = 2;
                            L.Color = 'k';

                            xlabel('Time (s)')
                            ylabel('Normalized (%RC)')
                            title('Hopping EMG Normalized to Reference Contraction (Max Height Single-leg Vertical Jump) - No Bandpass Filter')
                            hold off

                             %Use linkaxes so that any Zooming in applies to all subplots
                            linkaxes( [ X1 X2 X3 X4 ], 'xy')

                            savefig( [ ParticipantList{ n }, '_', 'Check Quality of Normalization - 30 Hz Bandpass vs No Bandpass ', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                            pause



                            close all
                            
                             %End the If statement - whether to show the plot for Participant N   

                         end
                                    
                                    
                                    


%%  !! BEGIN S Loop - Splitting Data Into Individual Hops                            
                                    for s = 1 : numel( GContactBegin_FrameNumbers(:,p) )





                                        %Pull out the indices for the first frame of the ground contact
                                        %phase, in terms of EMG sampling Hz
                                        GContactBegin_MoCapFrameNumbers = IndexingIntoData_HoppingRateB_DataStructure.BeginGroundContact_MoCapFrames;
        
                                        %Pull out the Frames for the last frame of the ground contact
                                        %phase, in terms of EMG sampling Hz
                                        GContactEnd_MoCapFrameNumbers = IndexingIntoData_HoppingRateB_DataStructure.EndGroundContact_forContactPhase_MoCapFrames;
        
                                        %Pull out the frame numbers for the beginning of flight pahse, relative
                                        %to entire trial
                                        BeginFlight_MoCapFrameNumbers =  IndexingIntoData_HoppingRateB_DataStructure.EndGroundContact_forFlightPhase_MoCapFrames;



                                        %Find the length of the entire hop cycle for the Sth hop, in
                                        %MoCap Frames
                                        LengthofHop_MoCapData = IndexingIntoData_HoppingRateB_DataStructure.LengthofEntireHopCycle_NonTruncated_MoCapSamplingHz( s ) - 1;

                                        %Find the length of the flight phase for the Sth hop, in
                                        %MoCap Frames
                                        LengthofFlightPhase_MoCapData = IndexingIntoData_HoppingRateB_DataStructure.LengthofFlightPhase_NonTruncated_MoCapSamplingHz( s );


                                        %Create a vector containing all Frames for the Sth hop (in MoCap Frames), from the
                                        %beginning of one flight phase and the beginning of the next. Subtract
                                        %one from the GContactEnd frame number since the frame number is the
                                        %first frame of flight phase. Want to end at the last frame of contact
                                        %phase
                                        AllFrames_SthHop_MoCap = 1 : LengthofHop_MoCapData;



                                        %Create a vector containing the frames for the flight phase, in
                                        %MoCap frames
                                        FlightPhaseFrames_SthHop_MoCap = 1 : LengthofFlightPhase_MoCapData;



                                        %Store the ankle angle for the entire hop in a new variable
                                        AnkleAngle_EntireSthHop = AnkleSagittalAngle( AllFrames_SthHop_MoCap, s );

                                        
                                        %Store the ankle angle for the flight phase in a new variable
                                        AnkleAngle_FlightPhaseSthHop = AnkleSagittalAngle( FlightPhaseFrames_SthHop_MoCap, s );


                                        %Create a vector containing all Frames for the Sth hop, from the
                                        %beginning of one flight phase and the beginning of the next. Subtract
                                        %one from the GContactEnd frame number since the frame number is the
                                        %first frame of flight phase. Want to end at the last frame of contact
                                        %phase
                                        AllFrames_SthHop_EMG = FirstDataPoint_SthHop_EMGSampHz(s,p) : GContactEnd_FrameNumbers(s,p);


                                        %Find the length of the entire hop cycle for the Sth hop
                                        LengthofHop_EMGData(s, p) =numel(AllFrames_SthHop_EMG);
                                        



                                        %Splice out the Sth hop by using the Frames for the Sth
                                        %hop. Do this for both the rectified and normalized EMG
                                        MuscleQ_Rectified_10HzBandpass_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Rectified_10HzBandpass(AllFrames_SthHop_EMG);
                                        MuscleQ_Smoothed_10HzBandpass_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Smoothed_10HzBandpass(AllFrames_SthHop_EMG);
                                        MuscleQ_Normalized_10HzBandpass_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Normalized_10HzBandpass(AllFrames_SthHop_EMG);

                                        MuscleQ_Rectified_30HzBandpass_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Rectified_30HzBandpass(AllFrames_SthHop_EMG);
                                        MuscleQ_Smoothed_30HzBandpass_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Smoothed_30HzBandpass(AllFrames_SthHop_EMG);
                                        MuscleQ_Normalized_30HzBandpass_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Normalized_30HzBandpass(AllFrames_SthHop_EMG);

                                        MuscleQ_Rectified_NoBandpass_IndividualHops( 1 : LengthofHop_EMGData( s, p ), s ) = MuscleQ_Rectified_NoBandpass( AllFrames_SthHop_EMG );
                                        MuscleQ_Normalized_NoBandpass_IndividualHops( 1 : LengthofHop_EMGData( s, p ), s ) = MuscleQ_Normalized_NoBandpass( AllFrames_SthHop_EMG );

                                        MuscleQ_Highpassed4Coherence_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Highpassed4Coherence(AllFrames_SthHop_EMG);
                                        MuscleQ_Rectified4Coherence_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_Rectified_forCoherence(AllFrames_SthHop_EMG);


                                        MuscleQ_DoublePassSmoothed_30HzBandpass_IndividualHops(1 : LengthofHop_EMGData(s,p),s) = MuscleQ_DoublePassSmoothed_30HzBandpass(AllFrames_SthHop_EMG);

                                        %Create a vector containing the Frames of the ground
                                        %contact phase for the Sth hop
                                        AllFrames_SthHopContactPhase_EMG = GContactBegin_FrameNumbers(s,p) : GContactEnd_FrameNumbers(s,p);

                                        %Find the number of elements of the Sth hop contact phase.
                                        NumEl_SthHopContactPhase_EMGSamplingHz(s,p) = numel(AllFrames_SthHopContactPhase_EMG);



                                        %Splice out the contact phase of the Sth hop. Do this for
                                        %the high-pass filtered (for coherence), rectified, smoothed and normalized EMG
                                        MuscleQ_Highpassed4Coherence_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Highpassed4Coherence( AllFrames_SthHopContactPhase_EMG );
                                        
                                        MuscleQ_Rectified4Coherence_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Rectified_forCoherence( AllFrames_SthHopContactPhase_EMG );
                                        
                                        MuscleQ_Rectified_10HzBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Rectified_10HzBandpass( AllFrames_SthHopContactPhase_EMG );

                                        MuscleQ_Smoothed_10HzBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Smoothed_10HzBandpass( AllFrames_SthHopContactPhase_EMG );

                                        MuscleQ_Normalized_10HzBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Normalized_10HzBandpass( AllFrames_SthHopContactPhase_EMG );
                                        
                                        MuscleQ_Rectified_30HzBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Rectified_30HzBandpass( AllFrames_SthHopContactPhase_EMG );

                                        MuscleQ_Smoothed_30HzBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Smoothed_30HzBandpass( AllFrames_SthHopContactPhase_EMG );

                                        MuscleQ_Normalized_30HzBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Normalized_30HzBandpass( AllFrames_SthHopContactPhase_EMG );
                                        
                                        MuscleQ_Rectified_NoBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Rectified_NoBandpass( AllFrames_SthHopContactPhase_EMG );

                                        MuscleQ_Normalized_NoBandpass_IndividualHops_ContactPhase(1:NumEl_SthHopContactPhase_EMGSamplingHz(s,p),s) = MuscleQ_Normalized_NoBandpass( AllFrames_SthHopContactPhase_EMG );
                                        
%% Plot the individual hops to check for errors in the splitting 

                                %Only show the figure below if we told the code to show all figures
                                %for Participant N
                                if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )

                                    %Only show the figure below if the very last hop has been
                                    %segmented from the entire trial
                                   if s ==  numel(GContactBegin_FrameNumbers(:,p))
                                        
                                       
                                       
                                       %Create time vector for plotting EMG after splitting it into
                                       %individual hops
                                       TimeVector_IndividualHops = ( 1 : size( MuscleQ_Rectified4Coherence_IndividualHops_ContactPhase, 1) ) ./ EMGSampHz;
                                       
                                       
                                       
                                        %Plot the EMG after splitting into individual hops - 10 Hz
                                        %Bandpass Filter
                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Splitting EMG into Individual Hops - 10 Hz Bandpass Filter ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                        sgtitle( ['Check Quality of Splitting EMG into Individual Hops - 10 Hz Bandpass Filter ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ], 'FontSize', 20 )
                                        
                                        %Subplot 1
                                        X1 = subplot(4, 1, 1); 
                                        plot(TimeVector_IndividualHops',MuscleQ_Rectified4Coherence_IndividualHops_ContactPhase,'LineWidth',2 )
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Rectified for Coherence - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off

                                        %Subplot 2
                                        subplot(4, 1, 2)
                                        X2 = plot(TimeVector_IndividualHops',MuscleQ_Rectified_10HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 ); 
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Rectified - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off
                                        

                                        %Subplot 3
                                        subplot(4, 1, 3)
                                        X3 = plot(TimeVector_IndividualHops',MuscleQ_Smoothed_10HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 ); 
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Smoothed - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off
                                        
                                        %Subplot 4
                                        subplot(4, 1, 4)
                                        X4 = plot(TimeVector_IndividualHops',MuscleQ_Normalized_10HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 ); 
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel('Normalized (%RC)')
                                        title('Hopping EMG Normalized - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off

                                        savefig( [ ParticipantList{ n }, '_', 'Check Quality of Splitting Into Individual Hops - 10 Hz Bandpass Filter', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                                        pause%Plot the EMG after splitting into individual hops
                                       
                                       

%% Plot the 30 Hz Bandpass Filtered Data After Splitting Into Individual Hops
                                       
                                        %Plot the EMG after splitting into individual hops - 30 Hz
                                        %Bandpass Filter
                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Splitting EMG into Individual Hops - 30 Hz Bandpass Filter ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                        sgtitle( ['Check Quality of Splitting EMG into Individual Hops - 30 Hz Bandpass Filter ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ], 'FontSize', 20 )
                                        %Subplot 1
                                        X1 = subplot(4, 1, 1); 
                                        plot(TimeVector_IndividualHops',MuscleQ_Rectified4Coherence_IndividualHops_ContactPhase,'LineWidth',2 )
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Rectified for Coherence - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off

                                        %Subplot 2
                                        subplot(4, 1, 2)
                                        X2 = plot(TimeVector_IndividualHops',MuscleQ_Rectified_30HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 ); 
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Rectified - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off
                                        

                                        %Subplot 3
                                        subplot(4, 1, 3)
                                        X3 = plot(TimeVector_IndividualHops',MuscleQ_Smoothed_30HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 ); 
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Smoothed - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off
                                        
                                        %Subplot 4
                                        subplot(4, 1, 4)
                                        X4 = plot(TimeVector_IndividualHops',MuscleQ_Normalized_30HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 ); 
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel('Normalized (%RC)')
                                        title('Hopping EMG Normalized - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off

                                        savefig( [ ParticipantList{ n }, '_', 'Check Quality of Splitting Into Individual Hops - 30 Hz Bandpass Filter', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                                        pause%Plot the EMG after splitting into individual hops
                                       
                                       

%% Plot the 30 Hz and No Bandpass Filtered Data After Splitting Into Individual Hops
                                       
                                        %Plot the EMG after splitting into individual hops - 30 Hz
                                        %Bandpass Filter
                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Splitting EMG into Individual Hops - 30 Hz Bandpass Filter and No Bandpass Filter ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                        sgtitle( ['Check Quality of Splitting EMG into Individual Hops - 30 Hz Bandpass Filter and No Bandpass Filter  ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ], 'FontSize', 20 )
                                        %Subplot 1
                                        X1 = subplot(4, 1, 1);
                                        plot(TimeVector_IndividualHops',MuscleQ_Rectified_30HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 );
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Rectified - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off


                                        %Subplot 2
                                        X2 = subplot(4, 1, 2);
                                        plot(TimeVector_IndividualHops',MuscleQ_Normalized_30HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 );
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel('Normalized (%RC)')
                                        title('Hopping EMG Normalized - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off
                                        

                                        %Subplot 3
                                        X3 = subplot(4, 1, 3);
                                        plot(TimeVector_IndividualHops',MuscleQ_Rectified_NoBandpass_IndividualHops_ContactPhase,'LineWidth',2 );
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel( RawHoppingUnits_string )
                                        title('Hopping EMG Rectified, No Bandpass Filter - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off
                                        
                                        %Subplot 4
                                        X4 = subplot(4, 1, 4);
                                        plot(TimeVector_IndividualHops',MuscleQ_Normalized_NoBandpass_IndividualHops_ContactPhase,'LineWidth',2 );
                                        hold on
                                        
                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                        %and color to black
                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                        L.LineWidth = 2;
                                        L.Color = 'k';
                                        
                                        xlabel('Time (s)')
                                        ylabel('Normalized (%RC)')
                                        title('Hopping EMG Normalized, No Bandpass Filter - Contact Phase')
                                        legend('Location','bestoutside')
                                        hold off

                                        savefig( [ ParticipantList{ n }, '_', 'Check Quality of Splitting Into Individual Hops - 30 Hz Bandpass Filter and No Bandpass Filter ', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );

                                        pause%Plot the EMG after splitting into individual hops


                                        
                                   %End the If statement ( show plot only after the last hop was segmented)     
                                   end
                                        
                                %End the outer If statement - whether or not to show the plot for Participant N          
                                 end
                                        

    %% Segment Out Entire Hop, Non-Truncated 
    
                                %Set the frames for the entire hop. This uses the beginning
                                %of flight phase for the individual hop, not the minimum
                                %flight phase length.
                                FramesforEntireHop = BeginFlight_FrameNumbers( s ) : ( GContactEnd_FrameNumbers( s ) - 1 );

                                MuscleQ_RectifiedEMG_10HzBandpass_IndividualHops_NonTruncated( 1 : numel( FramesforEntireHop ), s ) = MuscleQ_Rectified_10HzBandpass( FramesforEntireHop );
                                MuscleQ_SmoothedEMG_10HzBandpass_IndividualHops_NonTruncated( 1 : numel( FramesforEntireHop ), s ) = MuscleQ_Smoothed_10HzBandpass( FramesforEntireHop );
                                MuscleQ_NormalizedEMG_10HzBandpass_IndividualHops_NonTruncated( 1 : numel( FramesforEntireHop ), s ) = MuscleQ_Normalized_10HzBandpass( FramesforEntireHop );

                                MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( 1 : numel( FramesforEntireHop ), s ) = MuscleQ_Rectified_30HzBandpass( FramesforEntireHop );
                                MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated( 1 : numel( FramesforEntireHop ), s ) = MuscleQ_Smoothed_30HzBandpass( FramesforEntireHop );
                                MuscleQ_NormalizedEMG_30HzBandpass_IndividualHops_NonTruncated( 1 : numel( FramesforEntireHop ), s ) = MuscleQ_Normalized_30HzBandpass( FramesforEntireHop );

                                MuscleQ_DoublePassLE_30HzBandpass_IndividualHops_NonTruncated( 1 : numel( FramesforEntireHop ), s ) = MuscleQ_DoublePassSmoothed_30HzBandpass( FramesforEntireHop );

                                %If we are NOT processing the TA, pull out the TA EMG for
                                %plotting when visualizing pre-activation
                                if q ~= 5

                                    TATrialP = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{ n } ).IndividualHops.( LimbID{ a } ).( MuscleID{ numel( MuscleID ) } ).( HoppingRate_ID{b} ).( HoppingTrialNumber{ p } ).RectifiedEMG_30HzBandpass_NonTruncated;

                                    TATrialP_HopS = TATrialP( 1 : numel( FramesforEntireHop ), s );

                                end                                        
                        
                                        

    %% Plot the rectified EMG of an individual hop - visual assessment of pre-activation onset 

    %                                     TimeVector_IndividualHop = (1 : numel( FramesforEntireHop ) ) ./ EMGSampHz;
    %                                      
    %                                     figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Visual Onset of Pre-activation ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ' ,HoppingTrialNumber{p},' ', 'Hop',' ',num2str(s) ])
    %                                     chart = plot(TimeVector_IndividualHop, MuscleQ_Rectified_IndividualHops(1:numel( FramesforEntireHop ),s) ,'LineWidth',1.5,'Color','#0072BD');
    %                                     xlabel('Time (s)')
    %                                     ylabel( RawHoppingUnits_string )
    %                                     title(['Check Quality of Smoothing - 25 Hz Lowpass Cutoff', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', HoppingTrialNumber{p}])
    %                                     
    %                                     pause


    %% DownSample the Data

                                        %Create number sequence for downsampling. Ex: 1, 51, 101 - will
                                        %average frames 1 - 50, 51 - 100, etc
                                        NumberSequenceforDownSampling = 1 : NumberofElementstoAverageforDownSampling : LengthofHop_EMGData(s,p);

                                        %Find length of Hop T after downsampling. Store in variable
                                        DownsampledLength_ofHopS( s ) = numel(NumberSequenceforDownSampling);


                                            %Run once for each interval in NumberSequenceforDownSampling
                                            for u = 1:DownsampledLength_ofHopS( s )

                                                %If using the last interval, final value of that interval
                                                %should be the final value of
                                                %MuscleQ_Normalized_IndividualHops, not the final value of NumberSequenceforDownSampling
                                                if u == DownsampledLength_ofHopS(s)

                                                    %Average the values in the last interval
                                                    MuscleQ_Rectified_10HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Rectified_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u) : LengthofHop_EMGData(s,p),s));

                                                    MuscleQ_Normalized_10HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Normalized_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u) : LengthofHop_EMGData(s,p),s));

                                                    %Average the values in the last interval
                                                    MuscleQ_Rectified_30HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Rectified_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u) : LengthofHop_EMGData(s,p),s));

                                                    MuscleQ_Normalized_30HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Normalized_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u) : LengthofHop_EMGData(s,p),s));

                                                else

                                                    %Average the values in all intervals except the last
                                                    MuscleQ_Rectified_10HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Rectified_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u):(NumberSequenceforDownSampling(u+1)-1),s));

                                                    MuscleQ_Normalized_10HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Normalized_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u):(NumberSequenceforDownSampling(u+1)-1),s));

                                                    %Average the values in all intervals except the last
                                                    MuscleQ_Rectified_30HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Rectified_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u):(NumberSequenceforDownSampling(u+1)-1),s));

                                                    MuscleQ_Normalized_30HzBandpass_IndividualHops_Downsampled(u,s) =...
                                                        mean(MuscleQ_Normalized_10HzBandpass_IndividualHops(NumberSequenceforDownSampling(u):(NumberSequenceforDownSampling(u+1)-1),s));

                                                end


                                            end


%% Create Muscle Onset to Offset, Onset to GContact End if NOT Reprocessing Preactivation for That Muscle

                                            % if  strcmp( cell2mat( ReprocessPreactivation_Cell ), 'No' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'N' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'n' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'no' ) 
                                            % 
                                            %         %Find the number of frames for the duration of muscle
                                            %         %activation
                                            %         NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                            % 
                                            % 
                                            %         %Create matrices of muscle EMG containing only the periods in
                                            %         %which the muscle is active
                                            %         MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                            %         MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                            %         MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                            % 
                                            %         MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                            %         MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                            %         MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                            % 
                                            %         MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                            % 
                                            % 
                                            % 
                                            % 
                                            %         %Create a vector of the frames to use
                                            %         FramesToUse_OnsetToGContactEnd = FrameNumber_OnsetBeforeGContactBegin_EntireTrial( s ) : ( GContactEnd_FrameNumbers( s ) - 1 );
                                            % 
                                            %         %Create a matrix containing the recitifed EMG from
                                            %         %pre-activation onset to end of ground contact. Will repeat
                                            %         %for smoothed EMG and normalized EMG
                                            %         MuscleQ_Rectified_10HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Rectified_10HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                            %         MuscleQ_Smoothed_10HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Smoothed_10HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                            %         MuscleQ_Normalized_10HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Normalized_10HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                            % 
                                            %         MuscleQ_Rectified_30HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Rectified_30HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                            %         MuscleQ_Smoothed_30HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Smoothed_30HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                            %         MuscleQ_Normalized_30HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Normalized_30HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                            % 
                                            % 
                                            %         MuscleQ_Rectified4Coherence_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Rectified_forCoherence( FramesToUse_OnsetToGContactEnd  );
                                            % 
                                            % 
                                            % end
                                            

                                            
%% Check For Offset Of Activation During Flight Phase

                                            %Only analyze pre-activation if we said Yes when asked if we want to
                                            %reprocess pre-activation for Participant N
                                            if  strcmp( cell2mat( ReprocessingData_Cell ), 'Yes' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'Y' )|| strcmp( cell2mat( ReprocessingData_Cell ), 'y' )|| strcmp( cell2mat( ReprocessingData_Cell ), 'yes' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Yes' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Y' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'y' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'yes' )
                                                            
                                                %Will calculate time of muscle offset using the minimum difference between the muscle integrated EMG time
                                                %series and the reference line. Minimum difference because we calculated the diff as Reference - EMG.
                                                %Once the minimum difference starts to head towards 0, that should be a close approximation of muscle
                                                %offset. We'll also only use the time points from muscle onset to end of ground contact
    
    
                                                %Create a vector of the frames to use
                                                FramesToUse_FlightPhaseOnly = BeginFlight_FrameNumbers( s ) : ( GContactBegin_FrameNumbers( s ) - 1 );
    
                                                %Find the length of the hop, from onset to end of ground
                                                %contact, in seconds
                                                LengthofHop_FlightPhaseOffset_sec = numel( FramesToUse_FlightPhaseOnly ) ./ EMGSampHz;
    
    
    
                                                %The first data point of the integrated EMG needs to be 0
                                                MuscleQ_IntegratedEMG_FlightMuscleOffset(1,s) = 0;
    
    
                                                %Integrate the rectified EMG - entire hop cycle (AFTER preactivation). Use trapezoidal integration: 1/2 (Base 1 + Base 2) *
                                                %height, where height = time interval, Base 1 - rectified
                                                %EMG value for time point 1, Base 2 = rectified EMG value
                                                %for time point 2.
                                                for v = 1 : ( numel( FramesToUse_FlightPhaseOnly ) - 1)
    
    
                                                    MuscleQ_IntegratedEMG_FlightMuscleOffset(v+1,s) =...
                                                        0.5 .* ( ( MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v ) ) + MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v+1 ) ) ) *...
                                                        TimeInterval_forIntegratingEMG );
    
                                                end
                                                
                                                %Create time vector for Sth hop
                                                TimeVector_SthHop_MuscleOffset = ( 1 : numel( FramesToUse_FlightPhaseOnly )  )./EMGSampHz;
    
                                                %Normalize time such that time at end of trial = 1
                                                TimeVector_SthHop_MuscleOffset_Normalizedto1 = TimeVector_SthHop_MuscleOffset./ max(TimeVector_SthHop_MuscleOffset);
    
                                                %Find cumulative sum of integrated EMG
                                                MuscleQ_IntegratedEMG_FlightMuscleOffset_CumSum = cumsum( MuscleQ_IntegratedEMG_FlightMuscleOffset( 1 : numel( FramesToUse_FlightPhaseOnly ) , s ) );
    
                                                %Normalize EMG such that final summed value = 1
                                                MuscleQ_IntegratedEMG_CumSum_Normalized_MuscleOffset =...
                                                    MuscleQ_IntegratedEMG_FlightMuscleOffset_CumSum ./ MuscleQ_IntegratedEMG_FlightMuscleOffset_CumSum( numel( FramesToUse_FlightPhaseOnly ) );
    
                                                %Create reference line vectors for the x and y-axes. Will use
                                                %y-axis in actual calculation but use x-axis for plotting only
                                                ReferenceLine_MuscleOffset_XAxis = linspace( 0, 1, numel( FramesToUse_FlightPhaseOnly ) ); 
                                                ReferenceLine_MuscleOffset_YAxis = linspace( 0, 1, numel( FramesToUse_FlightPhaseOnly ) );
    
    
                                                %Find difference between reference line Y values and
                                                %cumulative sum vector for integrated EMG. Positive value =
                                                %reference line greater than integrated EMG
                                                MuscleQ_DifferencefromReferenceLine_MuscleOffset = ReferenceLine_MuscleOffset_YAxis' - MuscleQ_IntegratedEMG_CumSum_Normalized_MuscleOffset;
    
    
                                                %Find the minimum difference between the reference line and
                                                %integrated EMG values, to signify deactivation of muscle
                                                MinDifferencefromReferenceLine_MuscleOffset = min(MuscleQ_DifferencefromReferenceLine_MuscleOffset);
    
    
                                                 %In some cases, the muscle might already be activated at the
                                                %beginning of flight phase. This would result in the maximum
                                                %difference between the reference line and integrated EMG
                                                %being equal to 0. In this case, save the first frame as the frame number
                                                %corresponding to activation onset equal. This is the "if"
                                                %portion of the loop. In the "else" portion, will find the
                                                %frame number corresponding to the max difference between
                                                %reference line and integrated EMG. This is considered the
                                                %frame number of activation onset.
                                                if MinDifferencefromReferenceLine_MuscleOffset == 0
    
                                                    FrameNumber_MinDifferencefromReferenceLine_FlightMuscleOffset(s) = 1;
    
                                                else
    
                                                    FrameNumber_MinDifferencefromReferenceLine_FlightMuscleOffset(s) = find( MuscleQ_DifferencefromReferenceLine_MuscleOffset == MinDifferencefromReferenceLine_MuscleOffset );
    
                                                end
                                                
    
                                                %Find the difference between consecutive values of MuscleQ_DifferencefromReferenceLine_MuscleOffset 
                                                DiffBetweenReferenceLineValues_Offset = diff( MuscleQ_DifferencefromReferenceLine_MuscleOffset );
    
                                                %Initialize vector for checking accuracy of muscle offset
                                                FlightMuscleOffset_DoubleCheck = NaN(1);
    
                                                %Use this to tell the code which frames of
                                                %DiffBetweenReferenceLineValues_Offset to use
                                                z = 1;
    
    
                                                %Check whether the muscle offset is accurate. Look at all
                                                %time points before the muscle offset and require that the
                                                %difference between the reference line and the integrated EMG
                                                %be decreasing for 25 ms.
                                                while isnan( FlightMuscleOffset_DoubleCheck )
    
                                                    %Add one to z - this changes the frames we use from DiffBetweenReferenceLineValues_Offset
                                                    z = z + 1;
    
                                                    %We want to check 25 ms worth of data, so we need to make
                                                    %sure the last frame we start with is 25 ms before the
                                                    %end of the trial
                                                    if z <= numel( DiffBetweenReferenceLineValues_Offset  ) - 1 - 0.025*EMGSampHz
    
                                                        %If the values of
                                                        %MuscleQ_DifferencefromReferenceLine_MuscleOffset are
                                                        %becoming less negative for 25 ms, the frame of
                                                        %muscle offset is z.
                                                        if sum( DiffBetweenReferenceLineValues_Offset( z : z + 0.025*EMGSampHz ) > 0 ) == ceil( 0.025*EMGSampHz )
    
                                                            FlightMuscleOffset_DoubleCheck = z;
    
    
                                                        end
    
                                                    %If z is less than 25 ms before the end of the trial, set the muscle offset to be the end of the trial.    
                                                    else
    
                                                        FlightMuscleOffset_DoubleCheck = numel( MuscleQ_DifferencefromReferenceLine_MuscleOffset );
    
                                                    end
    
                                                end
    
                                                %Convert frame number into seconds, to find time point of
                                                %activation onset.
                                                TimePoint_MinDifferencefromReferenceLine_FlightMuscleOffset(s) = FrameNumber_MinDifferencefromReferenceLine_FlightMuscleOffset(s) ./ EMGSampHz;
                                                TimePoint_FlightMuscleOffset_DoubleCheck(s) = FlightMuscleOffset_DoubleCheck ./ EMGSampHz;
    
    
                                                %Pre-activation onset is how early muscle activates relative
                                                %to onset of ground contact phase. Therefore, need to
                                                %subtract the time point of activation onset (from the step
                                                %above) from the time point of ground contact onset - this
                                                %is our pre-activation onset.
                                                FrameofMuscleOffset_FlightPhase_EMGSampHz(s) = FrameNumber_MinDifferencefromReferenceLine_FlightMuscleOffset( s );
                                                FrameofMuscleOffset_FlightPhase_EMGSampHz_DoubleCheck(s) = FlightMuscleOffset_DoubleCheck;
    
    
                                                %Convert frame of muscle offset, relative to onset, into
                                                %seconds
                                                TimeofMuscleOffset_FlightPhase( s ) = FrameofMuscleOffset_FlightPhase_EMGSampHz( s ) ./ EMGSampHz;
                                                TimeofMuscleOffset_FlightPhase_DoubleCheck( s ) =  FrameofMuscleOffset_FlightPhase_EMGSampHz_DoubleCheck(s) ./ EMGSampHz;
    
    
                                                %Want to find the frame within the normalized time vector
                                                %that corresponds to activation onset. Will use this
                                                %when creating a plot to show the calculation method.
                                                NormalizedTime_MuscleOffset =  TimeVector_SthHop_MuscleOffset_Normalizedto1( FrameNumber_MinDifferencefromReferenceLine_FlightMuscleOffset(s) ); 
    
    
    
    

    
    %% Plot NonTruncated EMG                                            
    
                                                %Only show the figure below if we told the code to show all figures
                                                %for Participant N
                                                 if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )
                
                                                    %Only show the figure below if the very last hop has been
                                                    %segmented from the entire trial
                                                   if s ==  numel(GContactBegin_FrameNumbers(:,p))
                                                        
    
                                                        %Plot the EMG after splitting into individual hops
                                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Compare Entire Hop with Contact Phase Data ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ] )
                                            
                                                        sgtitle( ['Compare Entire Hop with Contact Phase Data ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', HoppingRate_ID{b} ], ...
                                                            'FontSize', 20 )
                                                       
                                                       %Create time vector for plotting EMG after splitting it into
                                                       %individual hops
                                                       TimeVector_IndividualHops_NonTruncated = ( 1 : size( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated, 1) ) ./ EMGSampHz;
    
    
                                                        %Subplot 1
                                                        subplot(4, 1, 1)
                                                        plot(TimeVector_IndividualHops',MuscleQ_Normalized_10HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 );
                                                        hold on
                                                        
                                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                                        %and color to black
                                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                                        L.LineWidth = 2;
                                                        L.Color = 'k';
                                                        
                                                        xlabel('Time (s)')
                                                        ylabel('Normalized (%RC)')
                                                        title('Hopping EMG Normalized - Contact Phase - 10 Hz Bandpass Filter')
                                                        legend('Location','bestoutside')
                                                        hold off
                                                       
    
    
                                                        subplot( 4, 1, 2 )
                                                        plot(TimeVector_IndividualHops_NonTruncated',MuscleQ_NormalizedEMG_10HzBandpass_IndividualHops_NonTruncated,'LineWidth',2 );
                                                        hold on
                                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                                        %and color to black
                                                        L = line( [min( TimeVector_IndividualHops_NonTruncated ), max( TimeVector_IndividualHops_NonTruncated ) ], [ 0, 0 ] );
                                                        L.LineWidth = 2;
                                                        L.Color = 'k';
                                                        
                                                        xlabel('Time (s)')
                                                        ylabel('Normalized (%RC)')
                                                        title('Hopping EMG Normalized - Entire Hop, Nontruncated - 10 Hz Bandpass Filter')
                                                        legend('Location','bestoutside')
                                                        hold off
    
    
    
                                                        %Subplot 1
                                                        subplot(4, 1, 3)
                                                        plot(TimeVector_IndividualHops',MuscleQ_Normalized_30HzBandpass_IndividualHops_ContactPhase,'LineWidth',2 );
                                                        hold on
                                                        
                                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                                        %and color to black
                                                        L = line( [min( TimeVector_IndividualHops ), max( TimeVector_IndividualHops ) ], [ 0, 0 ] );
                                                        L.LineWidth = 2;
                                                        L.Color = 'k';
                                                        
                                                        xlabel('Time (s)')
                                                        ylabel('Normalized (%RC)')
                                                        title('Hopping EMG Normalized - Contact Phase - 30 Hz Bandpass Filter')
                                                        legend('Location','bestoutside')
                                                        hold off
                                                       
    
                                                        subplot( 4, 1, 4 )
                                                        plot(TimeVector_IndividualHops_NonTruncated',MuscleQ_NormalizedEMG_30HzBandpass_IndividualHops_NonTruncated,'LineWidth',2 );
                                                        hold on
                                                        %Create a horizontal line at 0. Make it extend the entire time series length
                                                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                                                        %and color to black
                                                        L = line( [min( TimeVector_IndividualHops_NonTruncated ), max( TimeVector_IndividualHops_NonTruncated ) ], [ 0, 0 ] );
                                                        L.LineWidth = 2;
                                                        L.Color = 'k';
                                                        
                                                        xlabel('Time (s)')
                                                        ylabel('Normalized (%RC)')
                                                        title('Hopping EMG Normalized - Entire Hop, Nontruncated - 30 Hz Bandpass Filter')
                                                        legend('Location','bestoutside')
                                                        hold off
    
                                                         savefig( [ ParticipantList{ n }, '_', 'Compare Entire Hop with Contact Phase Data', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );
                
                                                        pause
                                                        
                                                   %End the If statement ( show plot only after the last hop was segmented)     
                                                   end
                                                        
                                                %End the outer If statement - whether or not to show the plot for Participant N          
                                                 end
    
    
    
    
    %% Find Preactivation Onset Time - SD Threshold Method
    
                                                if  strcmp( cell2mat( ReprocessSDPreactivation_Cell ), 'Yes' )

                                                    %Only use the SD Threshold Method for finding pre-activation
                                                    %osnet time for Medial Gastroc. This is to compare with
                                                    %Eugene's results. Don't need to do this for the
                                                    %self-selected hopping rate. Will use an else if when
                                                    %processing the left medial gastroc
                                                    if ~strcmp( HoppingRate_ID{ b }, 'PreferredHz' ) && strcmp( MuscleID{ q }, 'RMGas' ) 
            
                                                        %Initialize variables to find the pre-activation onset frame
                                                        %for each hop. These will be rewritten for each hop. They may
                                                        %contain more than one onset frame - we'll choose the best
                                                        %one
                                                            %Finding onset frame when using the resting EMG to
                                                            %determine the baseline
                                                        OnsetFrame_SDThreshold_RestingEMG_Temp = NaN( 1,1 );
                                                            %Finding onset frame when using the individual hop's baseline EMG to
                                                            %determine the baseline
                                                        OnsetFrame_SDThreshold_EachHopBaseline_Temp = NaN( 1,1 );
            
                                                        %Next two rows initialize variables for filling  the above
                                                        %two rows
                                                        RowtoFill_OnsetFrame_Eugene_EachHopBaseline = 1;
                                                            RowtoFill_OnsetFrame_Eugene_RestingEMG = 1;
            
            
            
                                                        %Set the time of ground contact, in seconds, relative to the
                                                        %beginning of the flight phase. Use the frame numbers
                                                        %relative to the individual hop
                                                        TimeofGContact_IndividualHop = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) ./ EMGSampHz;
            
                                                        %Set the time of ground contact, in seconds, relative to the
                                                        %beginning of the flight phase. Use the frame numbers
                                                        %relative to the entirel trial
                                                        TimeofGContact_EntireTrial = GContactBegin_FrameNumbers( s ) ./ EMGSampHz;
                                                       
            
                                                        %Length of integrated EMG
                                                        NumEl_SthHop_IntegratedEMG_FlightOnly(s) = numel( FramesToUse_FlightPhaseOnly ) - 1; 
            
                                                        
                                                        
            
                                                        %Determine onset threshold as 3 SD above baseline - use
                                                        %resting EMG as baseline
                                                        OnsetThreshold = mean( abs( MuscleQ_RestingEMG ) ) + ( 3*std( abs( MuscleQ_RestingEMG ) ) );
        
        
                                                        %Display message box so we know that we need to choose the
                                                        %baseline period
                                                        BaselineMessage = msgbox('\fontsize{15} CHOOSE THE BASELINE PERIOD',CreateStruct);
                                                        uiwait( BaselineMessage )
            
            
                                                        %Plot the rectified EMG of an individual hop - visual assessment of pre-activation onset 
                                                        TimeVector_IndividualHop = ( 1 : numel( FramesforEntireHop ) ) ./ EMGSampHz;
                
                                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Visual Onset of Pre-activation ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ' ,HoppingTrialNumber{p},' ', 'Hop',' ',num2str(s) ])
                                                        chart = plot( MuscleQ_Rectified_30HzBandpass( FramesforEntireHop ) ,'LineWidth',1.5,'Color','#0072BD');
                                                        xlabel('Frame Number')
                                                        ylabel( RawHoppingUnits_string )
                                                        title(['Visual Onset of Pre-activationf', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', HoppingTrialNumber{p},  'Hop',' ',num2str(s) ] )
                    
                                                        pause
    
                                                        %Create a prompt so we can manually adjust the
                                                        %muscle deactivation if needed
                                                        BaselineBeginFramePrompt =  'Enter the Frame for Beginning Baseline';
                                                        
                                                        %Use inputdlg function to create a dialogue box for the prompt created above.
                                                        %First arg is prompt, 2nd is title
                                                        BaselineBeginFrame_Cell = inputdlg( [ '\fontsize{15}' BaselineBeginFramePrompt ], 'Enter the Frame for Beginning Preactivation', [1 150], {'3'} ,CreateStruct);
    
    
                                                        %Create a prompt so we can manually adjust the
                                                        %muscle deactivation if needed
                                                        BaselineEndFramePrompt =  'Enter the Frame for Ending Baseline';
                                                        
                                                        %Use inputdlg function to create a dialogue box for the prompt created above.
                                                        %First arg is prompt, 2nd is title
                                                        BaselineEndFrame_Cell = inputdlg( [ '\fontsize{15}' BaselineEndFramePrompt ], 'Enter the Frame for Ending Baseline', [1 150], {'0'} ,CreateStruct);
    
    
    %                                                     %Use ginput  to find the beginning and end of the baseline
    %                                                     %period
    %                                                     [ BaselineBegin_X, BaselineBegin_Y ] = ginput( 1 );
    %                                                     [ BaselineEnd_X, BaselineEnd_Y ] = ginput( 1 );
            
                                                        close
            
                                                        BaselineBegin_X_EntireTrialFrames = FramesforEntireHop( 1 ) + str2double( cell2mat( BaselineBeginFrame_Cell ) ) ;
                                                        BaselineEnd_X_EntireTrialFrames = FramesforEntireHop( 1 ) + str2double( cell2mat( BaselineEndFrame_Cell ) ) ;
                                                        %Second onset threshold = use baseline for each hop. Take
                                                        %mean of baseline and find time when signal is at least 3 STD
                                                        %above baseline. 
                                                        OnsetTreshold_EachHop = mean( MuscleQ_Rectified_30HzBandpass( BaselineBegin_X_EntireTrialFrames : BaselineEnd_X_EntireTrialFrames ) ) +...
                                                            ( 3*std( MuscleQ_Rectified_30HzBandpass( BaselineBegin_X_EntireTrialFrames : BaselineEnd_X_EntireTrialFrames ) ) );
        
        
        
                                                    %Use if loop to run through each signal frame
                                                    for v = 1 : ( numel( FramesToUse_FlightPhaseOnly ) - 1 )
        
                                                        %If vth element is below the onset threshold (using
                                                        %resting EMG) and the next element is above the
                                                        %threshold, add the frame number to
                                                        %OnsetFrame_Eugene_RestingEMG
                                                        if MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v ) ) <= OnsetThreshold && MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v + 1 ) ) > OnsetThreshold
        
                                                            OnsetFrame_SDThreshold_RestingEMG_Temp( RowtoFill_OnsetFrame_Eugene_RestingEMG ) = v;
        
                                                            RowtoFill_OnsetFrame_Eugene_RestingEMG = RowtoFill_OnsetFrame_Eugene_RestingEMG + 1;
        
                                                        end
                                                        
                                                        %If vth element is below the onset threshold (using
                                                        %resting EMG) and the next element is above the
                                                        %threshold, add the frame number to
                                                        %OnsetFrame_Eugene_RestingEMG
                                                        if MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v ) ) <= OnsetTreshold_EachHop && MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v+1 ) ) > OnsetTreshold_EachHop
        
                                                            OnsetFrame_SDThreshold_EachHopBaseline_Temp( RowtoFill_OnsetFrame_Eugene_EachHopBaseline ) = v;
        
                                                            RowtoFill_OnsetFrame_Eugene_EachHopBaseline = RowtoFill_OnsetFrame_Eugene_EachHopBaseline + 1;
        
                                                        end
                                                    
                                                    end%End If statement for v = 
        
        
                    
                                                        %Pick the pre-activation onset frame as the largest frame.
                                                        OnsetFrame_SDThreshold_RestingEMG( s ) = min( OnsetFrame_SDThreshold_RestingEMG_Temp, [], 'omitnan' );
                                                        OnsetFrame_SDThreshold_EachHopBaseline( s ) = min( OnsetFrame_SDThreshold_EachHopBaseline_Temp, [], 'omitnan' );
        
                                                        %Find the pre-activation onset frame, relative to ground
                                                        %contact: frame numbers are relative to the entire trial.
                                                        %To do this, subtract OnsetFrame_Eugene_RestingEMG( s )
                                                        %from GContactBegin_FrameNumbers( s ), since this is in
                                                        %frame numbers for the entire trial
                                                        Frame_OnsetB4GContact_SDThreshold_RestingEMG_EntireTrial( s ) = GContactBegin_FrameNumbers( s ) - OnsetFrame_SDThreshold_RestingEMG( s );
        
                                                        %Find the pre-activation onset frame, relative to ground
                                                        %contact: frame numbers are relative to the individual hop.
                                                        %To do this, subtract OnsetFrame_Eugene_RestingEMG( s )
                                                        %from 1 + the length of the flight phase (numel(
                                                        %FramesToUse_FlightPhaseOnly ) + 1 )
                                                        Frame_OnsetB4Contact_SDThreshold_RestingEMG_IndividualHop( s ) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) - OnsetFrame_SDThreshold_RestingEMG( s );
        
                                                        %Repeat the above two lines of code but for
                                                        %pre-activation onset using the baseline of the
                                                        %individual hop
                                                        Frame_OnsetB4GContact_SDThreshold_EachHopBaseline_EntireTrial( s ) = GContactBegin_FrameNumbers( s ) - OnsetFrame_SDThreshold_EachHopBaseline( s );
                                                        Frame_OnsetB4Contact_SDThreshold_EachHopBaseline_IndividualHop( s ) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) - OnsetFrame_SDThreshold_EachHopBaseline( s );
        
        
                                                        %Find the time of pre-activation onset relative to the
                                                        %ground contact begins; use the frame numbers for the
                                                        %individual hop. Find this by subtracting
                                                        %Frame_OnsetB4Contact_Eugene_RestingEMG_IndividualHop(s)
                                                        %from TimeofGContact, then dividing by sampling rate
                                                        Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop( s ) =  TimeofGContact_IndividualHop - ( OnsetFrame_SDThreshold_RestingEMG( s )./EMGSampHz );
        
                                                         %Find the time of pre-activation onset relative to the
                                                        %ground contact begins; use the frame numbers for the
                                                        %entire trial. Find this by subtracting
                                                        %Frame_OnsetB4Contact_Eugene_RestingEMG_IndividualHop(s)
                                                        %from TimeofGContact, then dividing by sampling rate
                                                        Time_OnsetB4Contact_SDThreshold_RestEMG_EntireTrial( s ) =  TimeofGContact_EntireTrial - ( OnsetFrame_SDThreshold_RestingEMG( s )./EMGSampHz );
        
                                                        %Repeat the above two lines of code but for
                                                        %pre-activation onset using the baseline of the
                                                        %individual hop
                                                        Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop( s ) =  TimeofGContact_IndividualHop - ( OnsetFrame_SDThreshold_EachHopBaseline( s )./EMGSampHz );
                                                        Time_OnsetB4Contact_SDThreshold_BaselinePerHop_EntireTrial( s ) =  TimeofGContact_EntireTrial - ( OnsetFrame_SDThreshold_EachHopBaseline( s )./EMGSampHz );
        
        
                                                    elseif ~strcmp( HoppingRate_ID{ b }, 'PreferredHz' ) && strcmp( MuscleID{ q }, 'LMGas' )
            
                                                        %Initialize variables to find the pre-activation onset frame
                                                        %for each hop. These will be rewritten for each hop. They may
                                                        %contain more than one onset frame - we'll choose the best
                                                        %one
                                                            %Finding onset frame when using the resting EMG to
                                                            %determine the baseline
                                                        OnsetFrame_SDThreshold_RestingEMG_Temp = NaN( 1,1 );
                                                            %Finding onset frame when using the individual hop's baseline EMG to
                                                            %determine the baseline
                                                        OnsetFrame_SDThreshold_EachHopBaseline_Temp = NaN( 1,1 );
            
                                                        %Next two rows initialize variables for filling  the above
                                                        %two rows
                                                        RowtoFill_OnsetFrame_Eugene_EachHopBaseline = 1;
                                                            RowtoFill_OnsetFrame_Eugene_RestingEMG = 1;
            
            
            
                                                        %Set the time of ground contact, in seconds, relative to the
                                                        %beginning of the flight phase. Use the frame numbers
                                                        %relative to the individual hop
                                                        TimeofGContact_IndividualHop = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) ./ EMGSampHz;
            
                                                        %Set the time of ground contact, in seconds, relative to the
                                                        %beginning of the flight phase. Use the frame numbers
                                                        %relative to the entirel trial
                                                        TimeofGContact_EntireTrial = GContactBegin_FrameNumbers( s ) ./ EMGSampHz;
                                                       
            
                                                        %Length of integrated EMG
                                                        NumEl_SthHop_IntegratedEMG_FlightOnly(s) = numel( FramesToUse_FlightPhaseOnly ) - 1; 
            
                                                        
                                                        
            
                                                        %Determine onset threshold as 3 SD above baseline - use
                                                        %resting EMG as baseline
                                                        OnsetThreshold = mean( abs( MuscleQ_RestingEMG ) ) + ( 3*std( abs( MuscleQ_RestingEMG ) ) );
        
        
                                                        %Display message box so we know that we need to choose the
                                                        %baseline period
                                                        BaselineMessage = msgbox('\fontsize{15} CHOOSE THE BASELINE PERIOD',CreateStruct);
                                                        uiwait( BaselineMessage )
            
            
                                                        %Plot the rectified EMG of an individual hop - visual assessment of pre-activation onset 
                                                        TimeVector_IndividualHop = ( 1 : numel( FramesforEntireHop ) ) ./ EMGSampHz;
                
                                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Visual Onset of Pre-activation ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ' ,HoppingTrialNumber{p},' ', 'Hop',' ',num2str(s) ])
                                                        chart = plot( MuscleQ_Rectified_30HzBandpass( FramesforEntireHop ) ,'LineWidth',1.5,'Color','#0072BD');
                                                        xlabel('Frame Number')
                                                        ylabel( RawHoppingUnits_string )
                                                        title(['Visual Onset of Pre-activationf', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', HoppingTrialNumber{p},  'Hop',' ',num2str(s) ] )
                    
                                                        pause
    
                                                        %Create a prompt so we can manually adjust the
                                                        %muscle deactivation if needed
                                                        BaselineBeginFramePrompt =  'Enter the Frame for Beginning Baseline';
                                                        
                                                        %Use inputdlg function to create a dialogue box for the prompt created above.
                                                        %First arg is prompt, 2nd is title
                                                        BaselineBeginFrame_Cell = inputdlg( [ '\fontsize{15}' BaselineBeginFramePrompt ], 'Enter the Frame for Beginning Preactivation', [1 150], {'3'} ,CreateStruct);
    
    
                                                        %Create a prompt so we can manually adjust the
                                                        %muscle deactivation if needed
                                                        BaselineEndFramePrompt =  'Enter the Frame for Ending Baseline';
                                                        
                                                        %Use inputdlg function to create a dialogue box for the prompt created above.
                                                        %First arg is prompt, 2nd is title
                                                        BaselineEndFrame_Cell = inputdlg( [ '\fontsize{15}' BaselineEndFramePrompt ], 'Enter the Frame for Ending Baseline', [1 150], {'0'} ,CreateStruct);
    
    
    %                                                     %Use ginput  to find the beginning and end of the baseline
    %                                                     %period
    %                                                     [ BaselineBegin_X, BaselineBegin_Y ] = ginput( 1 );
    %                                                     [ BaselineEnd_X, BaselineEnd_Y ] = ginput( 1 );
            
                                                        close
            
                                                        BaselineBegin_X_EntireTrialFrames = FramesforEntireHop( 1 ) + str2double( cell2mat( BaselineBeginFrame_Cell ) ) ;
                                                        BaselineEnd_X_EntireTrialFrames = FramesforEntireHop( 1 ) + str2double( cell2mat( BaselineEndFrame_Cell ) ) ;
                                                        %Second onset threshold = use baseline for each hop. Take
                                                        %mean of baseline and find time when signal is at least 3 STD
                                                        %above baseline. 
                                                        OnsetTreshold_EachHop = mean( MuscleQ_Rectified_30HzBandpass( BaselineBegin_X_EntireTrialFrames : BaselineEnd_X_EntireTrialFrames ) ) +...
                                                            ( 3*std( MuscleQ_Rectified_30HzBandpass( BaselineBegin_X_EntireTrialFrames : BaselineEnd_X_EntireTrialFrames ) ) );
        
        
        
                                                    %Use if loop to run through each signal frame
                                                    for v = 1 : ( numel( FramesToUse_FlightPhaseOnly ) - 1 )
        
                                                        %If vth element is below the onset threshold (using
                                                        %resting EMG) and the next element is above the
                                                        %threshold, add the frame number to
                                                        %OnsetFrame_Eugene_RestingEMG
                                                        if MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v ) ) <= OnsetThreshold && MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v + 1 ) ) > OnsetThreshold
        
                                                            OnsetFrame_SDThreshold_RestingEMG_Temp( RowtoFill_OnsetFrame_Eugene_RestingEMG ) = v;
        
                                                            RowtoFill_OnsetFrame_Eugene_RestingEMG = RowtoFill_OnsetFrame_Eugene_RestingEMG + 1;
        
                                                        end
                                                        
                                                        %If vth element is below the onset threshold (using
                                                        %resting EMG) and the next element is above the
                                                        %threshold, add the frame number to
                                                        %OnsetFrame_Eugene_RestingEMG
                                                        if MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v ) ) <= OnsetTreshold_EachHop && MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v+1 ) ) > OnsetTreshold_EachHop
        
                                                            OnsetFrame_SDThreshold_EachHopBaseline_Temp( RowtoFill_OnsetFrame_Eugene_EachHopBaseline ) = v;
        
                                                            RowtoFill_OnsetFrame_Eugene_EachHopBaseline = RowtoFill_OnsetFrame_Eugene_EachHopBaseline + 1;
        
                                                        end
                                                    
                                                    end%End If statement for v = 
        
        
                    
                                                        %Pick the pre-activation onset frame as the largest frame.
                                                        OnsetFrame_SDThreshold_RestingEMG( s ) = min( OnsetFrame_SDThreshold_RestingEMG_Temp, [], 'omitnan' );
                                                        OnsetFrame_SDThreshold_EachHopBaseline( s ) = min( OnsetFrame_SDThreshold_EachHopBaseline_Temp, [], 'omitnan' );
        
                                                        %Find the pre-activation onset frame, relative to ground
                                                        %contact: frame numbers are relative to the entire trial.
                                                        %To do this, subtract OnsetFrame_Eugene_RestingEMG( s )
                                                        %from GContactBegin_FrameNumbers( s ), since this is in
                                                        %frame numbers for the entire trial
                                                        Frame_OnsetB4GContact_SDThreshold_RestingEMG_EntireTrial( s ) = GContactBegin_FrameNumbers( s ) - OnsetFrame_SDThreshold_RestingEMG( s );
        
                                                        %Find the pre-activation onset frame, relative to ground
                                                        %contact: frame numbers are relative to the individual hop.
                                                        %To do this, subtract OnsetFrame_Eugene_RestingEMG( s )
                                                        %from 1 + the length of the flight phase (numel(
                                                        %FramesToUse_FlightPhaseOnly ) + 1 )
                                                        Frame_OnsetB4Contact_SDThreshold_RestingEMG_IndividualHop( s ) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) - OnsetFrame_SDThreshold_RestingEMG( s );
        
                                                        %Repeat the above two lines of code but for
                                                        %pre-activation onset using the baseline of the
                                                        %individual hop
                                                        Frame_OnsetB4GContact_SDThreshold_EachHopBaseline_EntireTrial( s ) = GContactBegin_FrameNumbers( s ) - OnsetFrame_SDThreshold_EachHopBaseline( s );
                                                        Frame_OnsetB4Contact_SDThreshold_EachHopBaseline_IndividualHop( s ) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) - OnsetFrame_SDThreshold_EachHopBaseline( s );
        
        
                                                        %Find the time of pre-activation onset relative to the
                                                        %ground contact begins; use the frame numbers for the
                                                        %individual hop. Find this by subtracting
                                                        %Frame_OnsetB4Contact_Eugene_RestingEMG_IndividualHop(s)
                                                        %from TimeofGContact, then dividing by sampling rate
                                                        Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop( s ) =  TimeofGContact_IndividualHop - ( OnsetFrame_SDThreshold_RestingEMG( s )./EMGSampHz );
        
                                                         %Find the time of pre-activation onset relative to the
                                                        %ground contact begins; use the frame numbers for the
                                                        %entire trial. Find this by subtracting
                                                        %Frame_OnsetB4Contact_Eugene_RestingEMG_IndividualHop(s)
                                                        %from TimeofGContact, then dividing by sampling rate
                                                        Time_OnsetB4Contact_SDThreshold_RestEMG_EntireTrial( s ) =  TimeofGContact_EntireTrial - ( OnsetFrame_SDThreshold_RestingEMG( s )./EMGSampHz );
        
                                                        %Repeat the above two lines of code but for
                                                        %pre-activation onset using the baseline of the
                                                        %individual hop
                                                        Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop( s ) =  TimeofGContact_IndividualHop - ( OnsetFrame_SDThreshold_EachHopBaseline( s )./EMGSampHz );
                                                        Time_OnsetB4Contact_SDThreshold_BaselinePerHop_EntireTrial( s ) =  TimeofGContact_EntireTrial - ( OnsetFrame_SDThreshold_EachHopBaseline( s )./EMGSampHz );
        
                                                        
                                                    %If we are not processing the 2.0 Hz or 2.33 Hz rate for the
                                                    %medial gastroc, execute the indented code
                                                    else
        
                                                        %Second onset threshold = use baseline for each hop. Take
                                                        %mean of baseline and find time when signal is at least 3 STD
                                                        %above baseline. 
                                                        OnsetTreshold_EachHop = NaN;
        
        
                    
                                                        %Pick the pre-activation onset frame as the largest frame.
                                                        OnsetFrame_SDThreshold_RestingEMG( s ) =NaN;
                                                        OnsetFrame_SDThreshold_EachHopBaseline( s ) = NaN;
        
                                                        %Find the pre-activation onset frame, relative to ground
                                                        %contact: frame numbers are relative to the entire trial.
                                                        %To do this, subtract OnsetFrame_Eugene_RestingEMG( s )
                                                        %from GContactBegin_FrameNumbers( s ), since this is in
                                                        %frame numbers for the entire trial
                                                        Frame_OnsetB4GContact_SDThreshold_RestingEMG_EntireTrial( s ) = NaN;
        
                                                        %Find the pre-activation onset frame, relative to ground
                                                        %contact: frame numbers are relative to the individual hop.
                                                        %To do this, subtract OnsetFrame_Eugene_RestingEMG( s )
                                                        %from 1 + the length of the flight phase (numel(
                                                        %FramesToUse_FlightPhaseOnly ) + 1 )
                                                        Frame_OnsetB4Contact_SDThreshold_RestingEMG_IndividualHop( s ) = NaN;
        
                                                        %Repeat the above two lines of code but for
                                                        %pre-activation onset using the baseline of the
                                                        %individual hop
                                                        Frame_OnsetB4GContact_SDThreshold_EachHopBaseline_EntireTrial( s ) = NaN;
                                                        Frame_OnsetB4Contact_SDThreshold_EachHopBaseline_IndividualHop( s ) = NaN;
        
        
                                                        %Find the time of pre-activation onset relative to the
                                                        %ground contact begins; use the frame numbers for the
                                                        %individual hop. Find this by subtracting
                                                        %Frame_OnsetB4Contact_Eugene_RestingEMG_IndividualHop(s)
                                                        %from TimeofGContact, then dividing by sampling rate
                                                        Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop( s ) =  NaN;
        
                                                         %Find the time of pre-activation onset relative to the
                                                        %ground contact begins; use the frame numbers for the
                                                        %entire trial. Find this by subtracting
                                                        %Frame_OnsetB4Contact_Eugene_RestingEMG_IndividualHop(s)
                                                        %from TimeofGContact, then dividing by sampling rate
                                                        Time_OnsetB4Contact_SDThreshold_RestEMG_EntireTrial( s ) = NaN;
        
                                                        %Repeat the above two lines of code but for
                                                        %pre-activation onset using the baseline of the
                                                        %individual hop
                                                        Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop( s ) =  NaN;
                                                        Time_OnsetB4Contact_SDThreshold_BaselinePerHop_EntireTrial( s ) =  NaN;
        
        
                                                    end


                                                else
        
                                                    %Restore the muscle onset frame, relative to the entire hop, using the
                                                    %SD threshold method. Baseline is Resting EMG.
                                                    OnsetFrame_SDThreshold_RestingEMG = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).MuscleOnsetFrame_SDThreshold_RestingEMG;
        
                                                    %Restore the muscle onset frame, relative to ground contact for the entire hop, using the
                                                    %SD threshold method. Baseline is Resting EMG.
                                                    Frame_OnsetB4Contact_SDThreshold_RestingEMG_IndividualHop = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).MuscleOnsetFrameB4GContact_SDThreshold_RestingEMG_IndividualHop;
        
                                                    %Restore the muscle onset frame, ground contact (frames relative to the entire trial), using the
                                                    %SD threshold method. Baseline is Resting EMG.
                                                    Frame_OnsetB4GContact_SDThreshold_RestingEMG_EntireTrial = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).MuscleOnsetFrameB4GContact_SDThreshold_RestingEMG_EntireTrial;
        
                                                    %Restore the muscle onset time, relative to ground contact for the entire hop, using the
                                                    %SD threshold method. Baseline is Resting EMG.
                                                    Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).MuscleOnsetTimeB4GContact_SDThreshold_RestingEMG_IndividualHop;
        
                                                    %Restore the muscle onset frame, relative to ground contact (time relative to the entire trial), using the
                                                    %SD threshold method. Baseline is Resting EMG.
                                                    Time_OnsetB4Contact_SDThreshold_RestEMG_EntireTrial = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).MuscleOnsetTimeB4GContact_SDThreshold_RestingEMG_EntireTrial;

                                                    
                
                                                    
        
                                                    %Restore the muscle onset frame, relative to the entire hop, using the
                                                    %SD threshold method. Baseline is determined for each
                                                    %hop.
                                                    OnsetFrame_SDThreshold_EachHopBaseline = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).MuscleOnsetFrame_SDThreshold_EachHopBaseline;
        
                                                    %Restore the muscle onset frame, relative to ground contact for the entire hop, using the
                                                    %SD threshold method. Baseline is determined for each
                                                    %hop.
                                                    Frame_OnsetB4Contact_SDThreshold_EachHopBaseline_IndividualHop = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).OnsetFrameB4GContact_SDThreshold_EachHopBaseline_IndividualHop;
        
                                                    %Restore the muscle onset frame, ground contact (frames relative to the entire trial), using the
                                                    %SD threshold method. Baseline is determined for each
                                                    %hop.
                                                    Frame_OnsetB4GContact_SDThreshold_EachHopBaseline_EntireTrial = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).OnsetFrameB4GContact_SDThreshold_EachHopBaseline_EntireTrial;
        
                                                    %Restore the muscle onset time, relative to ground contact for the entire hop, using the
                                                    %SD threshold method. Baseline is determined for each
                                                    %hop.
                                                    Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).OnsetTimeB4GContact_SDThreshold_EachHopBaseline_IndividualHop;
        
                                                    %Restore the muscle onset frame, relative to ground contact (time relative to the entire trial), using the
                                                    %SD threshold method. Baseline is determined for each
                                                    %hop.
                                                    Time_OnsetB4Contact_SDThreshold_BaselinePerHop_EntireTrial = David_DissertationEMGDataStructure.Post_Quals.( GroupList{m} ).( ParticipantList{n} ).IndividualHops.( LimbID{a} ).( MuscleID{q} ).( HoppingRate_ID{b} ).( HoppingTrialNumber{p} ).OnsetTimeB4GContact_SDThreshold_EachHopBaseline_EntireTrial;

                

                                                end
    
    


    
    
     %% Find Preactivation Onset Time - Santello-McDonagh Method
    
                                                %Set the time of ground contact, in seconds, relative to the
                                                %beginning of the flight phase.
                                                TimeofGContact_IndividualHop = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) ./ EMGSampHz;
                                               
    
                                                %Length of integrated EMG
                                                NumEl_SthHop_IntegratedEMG_FlightOnly(s) = numel( FramesToUse_FlightPhaseOnly ) - 1; 
    
                                                
                                                
                                                %Will use this for trapezoidal integration. Formula is 1/2
                                                %base times height, where base = time interval
                                                TimeInterval_forIntegratingEMG = 1./EMGSampHz;
    
                                                %First frame of integrated EMG must be 0
                                                MuscleQ_IntegratedEMG_EntireHop(1,s) = 0;
                                                MuscleQ_IntegratedEMG_FlightOnly(1,s) = 0;
    
                                                %Integrate the rectified EMG - entire hop cycle (flight +
                                                %ground contact). Use trapezoidal integration: 1/2 (Base 1 + Base 2) *
                                                %height, where height = time interval, Base 1 - rectified
                                                %EMG value for time point 1, Base 2 = rectified EMG value
                                                %for time point 2.
                                                for v = 1 : ( numel( FramesforEntireHop ) - 1)
    
    
                                                    MuscleQ_IntegratedEMG_EntireHop(v+1,s) =...
                                                        0.5 .* ( ( MuscleQ_Rectified_30HzBandpass( FramesforEntireHop( v ) ) + MuscleQ_Rectified_30HzBandpass( FramesforEntireHop( v+1 )) ) * TimeInterval_forIntegratingEMG );
    
    
                                                end
    
    
    
                                                 %Integrate the rectified EMG - flight phase only. Use trapezoidal integration: 1/2 (Base 1 + Base 2) *
                                                %height, where height = time interval, Base 1 - rectified
                                                %EMG value for time point 1, Base 2 = rectified EMG value
                                                %for time point 2.
                                                for v = 1 : NumEl_SthHop_IntegratedEMG_FlightOnly(s)
    
    
                                                    MuscleQ_IntegratedEMG_FlightOnly(v+1,s) =...
                                                        0.5 .* ( ( MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v ) ) + MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly( v+1) ) ) * TimeInterval_forIntegratingEMG );
    
    
                                                end
    
    
    
                                                %Create time vector for Sth hop
                                                TimeVector_SthHop_EntireHop = ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz;
                                                TimeVector_SthHop_FlightOnly = ( 1: numel( FramesToUse_FlightPhaseOnly ) )./EMGSampHz;
    
                                                %Normalize time such that time at end of trial = 1
                                                TimeVector_SthHop_EntireHop_Normalizedto1 = TimeVector_SthHop_EntireHop./ max(TimeVector_SthHop_EntireHop);
                                                TimeVector_SthHop_FlightOnly_Normalizedto1 = TimeVector_SthHop_FlightOnly./ max(TimeVector_SthHop_FlightOnly);
    
                                                %Find cumulative sum of integrated EMG
                                                MuscleQ_IntegratedEMG_EntireHop_CumSum = cumsum( MuscleQ_IntegratedEMG_EntireHop( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) , s ) );
                                                MuscleQ_IntegratedEMG_FlightOnly_CumSum = cumsum( MuscleQ_IntegratedEMG_FlightOnly( 1 : numel( FramesToUse_FlightPhaseOnly ) , s ) );
    
                                                %Normalize EMG such that final summed value = 1
                                                MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop =...
                                                    MuscleQ_IntegratedEMG_EntireHop_CumSum ./ MuscleQ_IntegratedEMG_EntireHop_CumSum( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) );
    
                                                MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly =...
                                                    MuscleQ_IntegratedEMG_FlightOnly_CumSum ./ MuscleQ_IntegratedEMG_FlightOnly_CumSum( numel( FramesToUse_FlightPhaseOnly ) );
    
                                                %Create reference line vectors for the x and y-axes. Will use
                                                %y-axis in actual calculation but use x-axis for plotting only
                                                ReferenceLine_EntireHop_XAxis = linspace( 0, 1, LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) );
                                                ReferenceLine_FlightOnly_XAxis = linspace( 0, 1, numel( FramesToUse_FlightPhaseOnly ) );
    
                                                ReferenceLine_EntireHop_YAxis = linspace( 0, 1, LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) );
                                                ReferenceLine_FlightOnly_YAxis = linspace( 0, 1, numel( FramesToUse_FlightPhaseOnly ) );
    
                                                %Find difference between reference line Y values and
                                                %cumulative sum vector for integrated EMG. Positive value =
                                                %reference line greater than integrated EMG
                                                MuscleQ_DifferencefromReferenceLine_EntireHop = ReferenceLine_EntireHop_YAxis' - MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop;
                                                MuscleQ_DifferencefromReferenceLine_FlightOnly = ReferenceLine_FlightOnly_YAxis' - MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly;
    
                                                %Find the maximum difference between the reference line and
                                                %integrated EMG values
                                                MaxDifferencefromReferenceLine_EntireHop = max(MuscleQ_DifferencefromReferenceLine_EntireHop);
                                                MaxDifferencefromReferenceLine_FlightOnly = max(MuscleQ_DifferencefromReferenceLine_FlightOnly); 
    
    
                                                
    
                                                 %In some cases, the muscle might already be activated at the
                                                %beginning of flight phase. This would result in the maximum
                                                %difference between the reference line and integrated EMG
                                                %being equal to 0. In this case, save the first frame as the frame number
                                                %corresponding to activation onset equal. This is the "if"
                                                %portion of the loop. In the "else" portion, will find the
                                                %frame number corresponding to the max difference between
                                                %reference line and integrated EMG. This is considered the
                                                %frame number of activation onset.
                                                if MaxDifferencefromReferenceLine_EntireHop == 0
    
                                                    FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s) = 1;
    
                                                else
    
                                                    FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s) = find( MuscleQ_DifferencefromReferenceLine_EntireHop == MaxDifferencefromReferenceLine_EntireHop );
    
                                                end
    
    
    
                                                PreactivationOnsetFrame_EntireHop_Method2_Temp = NaN(1);
                                                DiffBetweenReferenceLineValues_EntireHop = diff( MuscleQ_DifferencefromReferenceLine_EntireHop );
                                                z = 0;
                                                RowtoFill = 1;
                                                
                                                while z <= FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s)
    
                                                    z = z + 1;
    
                                                    if z <= ( numel( DiffBetweenReferenceLineValues_EntireHop ) - 1 - 0.025*EMGSampHz )
    
                                                        if sum( DiffBetweenReferenceLineValues_EntireHop( z : ( z + 0.025*EMGSampHz ) ) > 0 ) == ceil( 0.025*EMGSampHz )
    
                                                            PreactivationOnsetFrame_EntireHop_Method2_Temp( RowtoFill ) = z;
    
                                                            RowtoFill = RowtoFill + 1;
    
                                                        end
    
                                                    else
    
                                                        PreactivationOnsetFrame_EntireHop_Method2_Temp( RowtoFill ) = FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s);
    
                                                    end
    
                                                end
    
                                                PreactivationOnsetFrame_EntireHop_Method2 = max( PreactivationOnsetFrame_EntireHop_Method2_Temp );
    
                                                %In some cases, the muscle might already be activated at the
                                                %beginning of flight phase. This would result in the maximum
                                                %difference between the reference line and integrated EMG
                                                %being equal to 0. In this case, save the first frame as the frame number
                                                %corresponding to activation onset equal. This is the "if"
                                                %portion of the loop. In the "else" portion, will find the
                                                %frame number corresponding to the max difference between
                                                %reference line and integrated EMG. This is considered the
                                                %frame number of activation onset.
                                                if MaxDifferencefromReferenceLine_FlightOnly == 0
    
                                                    FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) = 1;
    
                                                elseif sum( MuscleQ_DifferencefromReferenceLine_FlightOnly > 0 ) < 10
    
                                                    FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) = 1;
    
                                                else
    
                                                    FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) = find( MuscleQ_DifferencefromReferenceLine_FlightOnly == MaxDifferencefromReferenceLine_FlightOnly );
    
                                                end
    
    
                                                %Convert frame number into seconds, to find time point of
                                                %activation onset.
                                                TimePoint_MaxDifferencefromReferenceLine_EntireHop( s ) = FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s) ./ EMGSampHz;
                                                TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ) = PreactivationOnsetFrame_EntireHop_Method2 ./ EMGSampHz;
                                                TimePoint_MaxDifferencefromReferenceLine_FlightOnly( s ) = FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) ./ EMGSampHz;
    
    
                                                %Pre-activation onset is how early muscle activates relative
                                                %to onset of ground contact phase. Therefore, need to
                                                %subtract the time point of activation onset (from the step
                                                %above) from the time point of ground contact onset - this
                                                %is our pre-activation onset.
                                                FrameNumber_OnsetBeforeGContactBegin_EntireHop(s) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) - FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s);
                                                FrameNumber_OnsetBeforeGContactBegin_EntireHop_Method2(s) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) - PreactivationOnsetFrame_EntireHop_Method2 ;
                                                FrameNumber_OnsetBeforeGContactBegin_FlightOnly(s) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) - FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s);
                                                FrameNumber_OnsetBeforeGContactBegin_EntireTrial( s ) = GContactBegin_FrameNumbers( s ) - FrameNumber_OnsetBeforeGContactBegin_FlightOnly(s);
    
    
                                                %Find the time, in seconds, of pre-activation onset
                                                TimePoint_OnsetBeforeGContactBegin_EntireHop(s) = TimeofGContact_IndividualHop - TimePoint_MaxDifferencefromReferenceLine_EntireHop(s);
                                                TimePoint_OnsetBeforeGContactBegin_EntireHop_Method2(s) = TimeofGContact_IndividualHop - TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2(s);
                                                TimePoint_OnsetBeforeGContactBegin_FlightOnly(s) = TimeofGContact_IndividualHop - TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s);
                                                TimePoint_OnsetBeforeGContactBegin_EntireTrial(s) = FrameNumber_OnsetBeforeGContactBegin_EntireTrial( s ) ./ EMGSampHz ;
    
    
                                                %Want to find the frame within the normalized time vector
                                                %that corresponds to activation onset. Will use this
                                                %when creating a plot to show the calculation method.
                                                PreactivationOnset_NormalizedTime_EntireHop =  TimeVector_SthHop_EntireHop_Normalizedto1( FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s) );
                                                PreactivationOnset_NormalizedTime_FlightOnly =  TimeVector_SthHop_FlightOnly_Normalizedto1( FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) );
    
    
    
    
    
    %% Calculate Time of Muscle Offset, After Onset
    
    %Will calculate time of muscle offset using the minimum difference between the muscle integrated EMG time
    %series and the reference line. Minimum difference because we calculated the diff as Reference - EMG.
    %Once the minimum difference starts to head towards 0, that should be a close approximation of muscle
    %offset. We'll also only use the time points from muscle onset to end of ground contact
    

                                                %Create a vector of the frames to use
                                                FramesToUse_OnsetToGContactEnd = FrameNumber_OnsetBeforeGContactBegin_EntireTrial( s ) : ( GContactEnd_FrameNumbers( s ) - 1 );
    
                                                %Find the length of the hop, from onset to end of ground
                                                %contact, in seconds
                                                LengthofHop_OnsetToGContactEnd_sec = numel( FramesToUse_OnsetToGContactEnd ) ./ EMGSampHz;
    
    
                                                %Create a matrix containing the recitifed EMG from
                                                %pre-activation onset to end of ground contact. Will repeat
                                                %for smoothed EMG and normalized EMG
                                                MuscleQ_Rectified_10HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Rectified_10HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                                MuscleQ_Smoothed_10HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Smoothed_10HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                                MuscleQ_Normalized_10HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Normalized_10HzBandpass( FramesToUse_OnsetToGContactEnd  );
    
                                                MuscleQ_Rectified_30HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Rectified_30HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                                MuscleQ_Smoothed_30HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Smoothed_30HzBandpass( FramesToUse_OnsetToGContactEnd  );
                                                MuscleQ_Normalized_30HzBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Normalized_30HzBandpass( FramesToUse_OnsetToGContactEnd  );
    
    
                                                MuscleQ_Rectified_NoBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Rectified_NoBandpass( FramesToUse_OnsetToGContactEnd  );
                                                MuscleQ_Normalized_NoBandpass_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Normalized_NoBandpass( FramesToUse_OnsetToGContactEnd  );

                                                MuscleQ_Rectified4Coherence_OnsettoGContactEnd( 1 : numel( FramesToUse_OnsetToGContactEnd )  , s ) = MuscleQ_Rectified_forCoherence( FramesToUse_OnsetToGContactEnd  );
    
    
    
                                                %The first data point of the integrated EMG needs to be 0
                                                MuscleQ_IntegratedEMG_MuscleOffset(1,s) = 0;
    
    
                                                %Integrate the rectified EMG - entire hop cycle (AFTER preactivation). Use trapezoidal integration: 1/2 (Base 1 + Base 2) *
                                                %height, where height = time interval, Base 1 - rectified
                                                %EMG value for time point 1, Base 2 = rectified EMG value
                                                %for time point 2.
                                                for v = 1 : ( numel( FramesToUse_OnsetToGContactEnd ) - 1)
    
    
                                                    MuscleQ_IntegratedEMG_MuscleOffset(v+1,s) =...
                                                        0.5 .* ( ( MuscleQ_Rectified_30HzBandpass( FramesToUse_OnsetToGContactEnd( v )  ) + MuscleQ_Rectified_30HzBandpass( FramesToUse_OnsetToGContactEnd( v+1 )  ) ) *...
                                                        TimeInterval_forIntegratingEMG );
    
                                                end
                                                
                                                %Create time vector for Sth hop
                                                TimeVector_SthHop_MuscleOffset = ( 1 : numel( FramesToUse_OnsetToGContactEnd )  )./EMGSampHz;
    
                                                %Normalize time such that time at end of trial = 1
                                                TimeVector_SthHop_MuscleOffset_Normalizedto1 = TimeVector_SthHop_MuscleOffset./ max(TimeVector_SthHop_MuscleOffset);
    
                                                %Find cumulative sum of integrated EMG
                                                MuscleQ_IntegratedEMG_MuscleOffset_CumSum = cumsum( MuscleQ_IntegratedEMG_MuscleOffset( 1 : numel( FramesToUse_OnsetToGContactEnd ) , s ) );
    
                                                %Normalize EMG such that final summed value = 1
                                                MuscleQ_IntegratedEMG_CumSum_Normalized_MuscleOffset =...
                                                    MuscleQ_IntegratedEMG_MuscleOffset_CumSum ./ MuscleQ_IntegratedEMG_MuscleOffset_CumSum( numel( FramesToUse_OnsetToGContactEnd ) );
    
                                                %Create reference line vectors for the x and y-axes. Will use
                                                %y-axis in actual calculation but use x-axis for plotting only
                                                ReferenceLine_MuscleOffset_XAxis = linspace( 0, 1, numel( FramesToUse_OnsetToGContactEnd ) );
                                                ReferenceLine_MuscleOffset_YAxis = linspace( 0, 1, numel( FramesToUse_OnsetToGContactEnd ) );
    
    
                                                %Find difference between reference line Y values and
                                                %cumulative sum vector for integrated EMG. Positive value =
                                                %reference line greater than integrated EMG
                                                MuscleQ_DifferencefromReferenceLine_MuscleOffset = ReferenceLine_MuscleOffset_YAxis' - MuscleQ_IntegratedEMG_CumSum_Normalized_MuscleOffset;
    
    
                                                %Find the minimum difference between the reference line and
                                                %integrated EMG values, to signify deactivation of muscle
                                                MinDifferencefromReferenceLine_MuscleOffset = min(MuscleQ_DifferencefromReferenceLine_MuscleOffset);
    
    
                                                 %In some cases, the muscle might already be activated at the
                                                %beginning of flight phase. This would result in the maximum
                                                %difference between the reference line and integrated EMG
                                                %being equal to 0. In this case, save the first frame as the frame number
                                                %corresponding to activation onset equal. This is the "if"
                                                %portion of the loop. In the "else" portion, will find the
                                                %frame number corresponding to the max difference between
                                                %reference line and integrated EMG. This is considered the
                                                %frame number of activation onset.
                                                if MinDifferencefromReferenceLine_MuscleOffset == 0
    
                                                    FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) = 1;
    
                                                else
    
                                                    FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) = find( MuscleQ_DifferencefromReferenceLine_MuscleOffset == MinDifferencefromReferenceLine_MuscleOffset ) + 1;
    
                                                end
                                                
    
                                                %Find the difference between consecutive values of MuscleQ_DifferencefromReferenceLine_MuscleOffset 
                                                DiffBetweenReferenceLineValues_Offset = diff( MuscleQ_DifferencefromReferenceLine_MuscleOffset );
    
                                                %Create a new vector containing only the difference between
                                                %reference line values at/after the minimum difference
                                                DiffBetweenReferenceLineValues_Offset_FramesAfterMinDifference = DiffBetweenReferenceLineValues_Offset( FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) : numel( DiffBetweenReferenceLineValues_Offset) );
    
                                                %If the difference between reference line and integrated EMG
                                                %begins increasing again after reaching its min, we'll look
                                                %for the next frame when the difference decreases. Remember that
                                                %DiffBetweenReferenceLineValues_Offset is found by taking
                                                %(n+1) - n --> if n+1 is more negative, the difference is
                                                %negative. If n+1 is less negative, the difference is
                                                %positive. We'll look for the time point when this becomes
                                                %positive after becoming negative again.
                                                if sum(  DiffBetweenReferenceLineValues_Offset_FramesAfterMinDifference < 0 ) >= 1
    
                                                    %Find the first negative element in
                                                    %DiffBetweenReferenceLineValues_Offset_FramesAfterMinDifference.
                                                    %This is the first frame where the difference between
                                                    %reference line values became more negative compared to
                                                    %the preceding value.
                                                    FrameofIncreasingActivation = find( DiffBetweenReferenceLineValues_Offset_FramesAfterMinDifference < 0, 1, 'last' );
    
                                                     %Find the second positive element in
                                                    %DiffBetweenReferenceLineValues_Offset_FramesAfterMinDifference
                                                    %AFTER FrameofIncreasingActivation.
                                                    %This is the first frame where the difference between
                                                    %reference line values becomes less negative compared to
                                                    %the preceding value. Take the second positive element to
                                                    %ensure there is a consistent positive
                                                    FrameofDecreasingAfterIncreasingActivation =...
                                                         find( DiffBetweenReferenceLineValues_Offset_FramesAfterMinDifference( FrameofIncreasingActivation : numel( DiffBetweenReferenceLineValues_Offset_FramesAfterMinDifference ) ) > 0, 1 );
                                                    
                                                    FrameNumber_MinDifferencefromReferenceLine_MuscleOffset( s ) = FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) + FrameofIncreasingActivation + FrameofDecreasingAfterIncreasingActivation;
    
                                                end
    
    
                                                %Initialize vector for checking accuracy of muscle offset
                                                MuscleOffsetAfterOnset_DoubleCheck = NaN(1);
    
                                                %Use this to tell the code which frames of
                                                %DiffBetweenReferenceLineValues_Offset to use
                                                z = FrameNumber_MinDifferencefromReferenceLine_MuscleOffset( s ) - 1;
    
    
                                                %Check whether the muscle offset is accurate. Look at all
                                                %time points before the muscle offset and require that the
                                                %difference between the reference line and the integrated EMG
                                                %be decreasing for 25 ms.
                                                while isnan( MuscleOffsetAfterOnset_DoubleCheck )
    
                                                    %Add one to z - this changes the frames we use from DiffBetweenReferenceLineValues_Offset
                                                    z = z + 1;
    
                                                    %We want to check 25 ms worth of data, so we need to make
                                                    %sure the last frame we start with is 25 ms before the
                                                    %end of the trial
                                                    if z <= numel( DiffBetweenReferenceLineValues_Offset  ) - 1 - ceil( 0.025*EMGSampHz )
    
                                                        %If the values of
                                                        %MuscleQ_DifferencefromReferenceLine_MuscleOffset are
                                                        %becoming less negative for 25 ms, the frame of
                                                        %muscle offset is z.
                                                        if sum( DiffBetweenReferenceLineValues_Offset( z : z + ceil( 0.025*EMGSampHz ) ) > 0 ) == ceil( 0.025*EMGSampHz )
    
                                                            MuscleOffsetAfterOnset_DoubleCheck = z;
    
    
                                                        end
    
                                                    %If z is less than 25 ms before the end of the trial, set the muscle offset to be the end of the trial.    
                                                    else
    
                                                        MuscleOffsetAfterOnset_DoubleCheck = numel( MuscleQ_DifferencefromReferenceLine_MuscleOffset );
    
                                                    end
    
                                                end
    
                                                %Convert frame number into seconds, to find time point of
                                                %activation onset.
                                                TimePoint_MinDifferencefromReferenceLine_MuscleOffset(s) = FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) ./ EMGSampHz;
                                                TimePoint_MuscleOffsetAfterOnset_DoubleCheck(s) = MuscleOffsetAfterOnset_DoubleCheck ./ EMGSampHz;
    
    
                                                %Pre-activation onset is how early muscle activates relative
                                                %to onset of ground contact phase. Therefore, need to
                                                %subtract the time point of activation onset (from the step
                                                %above) from the time point of ground contact onset - this
                                                %is our pre-activation onset.
                                                FrameofMuscleOffset_AfterOnset_EMGSampHz(s) = FrameNumber_MinDifferencefromReferenceLine_MuscleOffset( s );
                                                FrameofMuscleOffset_AfterOnset_EMGSampHz_DoubleCheck(s) = MuscleOffsetAfterOnset_DoubleCheck;
    
    
                                                %Convert frame of muscle offset, relative to onset, into
                                                %seconds
                                                TimeofMuscleOffset_AfterOnset( s ) = FrameofMuscleOffset_AfterOnset_EMGSampHz( s ) ./ EMGSampHz;
                                                TimeofMuscleOffset_AfterOnset_DoubleCheck( s ) =  FrameofMuscleOffset_AfterOnset_EMGSampHz_DoubleCheck(s) ./ EMGSampHz;
    
    
                                                %Want to find the frame within the normalized time vector
                                                %that corresponds to activation onset. Will use this
                                                %when creating a plot to show the calculation method.
                                                NormalizedTime_MuscleOffset =  TimeVector_SthHop_MuscleOffset_Normalizedto1( FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) );
    
    
                                                %Find the frame of muscle offset relative to the entire hop
                                                FrameofMuscleOffset_EntireHop_EMGSampHz( s ) = FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) + FrameofMuscleOffset_AfterOnset_EMGSampHz(s) - 1;
                                                FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) = FrameNumber_OnsetBeforeGContactBegin_EntireTrial( s ) + FrameofMuscleOffset_AfterOnset_EMGSampHz(s) - 1;
                                                FrameofMuscleOffset_EntireHop_EMGSampHz_DoubleCheck( s ) = FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) + FrameofMuscleOffset_AfterOnset_EMGSampHz_DoubleCheck(s) - 1;
                                                FrameofMuscleOffset_EntireTrial_EMGSampHz_DoubleCheck( s ) = FrameNumber_OnsetBeforeGContactBegin_EntireTrial( s ) + FrameofMuscleOffset_AfterOnset_EMGSampHz_DoubleCheck(s) - 1;
    
    
                                                %Convert frame of muscle offset, relative to entire hop, into
                                                %seconds
                                                TimeofMuscleOffset_EntireHop( s ) = FrameofMuscleOffset_EntireHop_EMGSampHz( s ) ./ EMGSampHz;
                                                TimeofMuscleOffset_EntireTrial( s ) = FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) ./ EMGSampHz;
                                                TimeofMuscleOffset_EntireHop_DoubleCheck( s ) = FrameofMuscleOffset_EntireHop_EMGSampHz_DoubleCheck( s ) ./ EMGSampHz;
                                                TimeofMuscleOffset_EntireTrial_DoubleCheck( s ) = TimePoint_OnsetBeforeGContactBegin_EntireTrial(s) + FrameofMuscleOffset_EntireTrial_EMGSampHz_DoubleCheck( s ) ./ EMGSampHz;
    
    
    
    
    
    %% Find second period of muscle activation
    
                                                %If the muscle de-activates before the end of the hop,
                                                %check for another period of muscle activation
                                                if TimeofMuscleOffset_EntireHop( s ) < ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) / EMGSampHz )
    
    
                                                    %Find all frames from the offset of Burst 1 to the end of
                                                    %the hop
                                                    FramesofHopS_Offset1ToGContactEnd = FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) : ( GContactEnd_FrameNumbers( s ) - 1 );
    
                                                    %Create a vector containing the EMG data from offset of
                                                    %the first muscle burst until the end of the hop
                                                    RectifiedEMG_Offset1ToGContactEnd = MuscleQ_Rectified_30HzBandpass( FramesofHopS_Offset1ToGContactEnd );
    
    
                                                    %First frame of integrated EMG must be 0
                                                    MuscleQ_IntegratedEMG_Offset1ToGContactEnd(1,s) = 0;
    
    
    
                                                     %Integrate the rectified EMG - flight phase only. Use trapezoidal integration: 1/2 (Base 1 + Base 2) *
                                                    %height, where height = time interval, Base 1 - rectified
                                                    %EMG value for time point 1, Base 2 = rectified EMG value
                                                    %for time point 2.
                                                    for v = 1 : ( numel( RectifiedEMG_Offset1ToGContactEnd ) - 1 )
        
        
                                                        MuscleQ_IntegratedEMG_Offset1ToGContactEnd(v+1,s) =...
                                                            0.5 .* ( ( RectifiedEMG_Offset1ToGContactEnd(v) + RectifiedEMG_Offset1ToGContactEnd(v+1) ) * TimeInterval_forIntegratingEMG );
        
        
                                                    end
        
        
                                                    %Create time vector for Sth hop
                                                    TimeVector_SthHop_OffsetToGContactEnd = ( 1 : numel( RectifiedEMG_Offset1ToGContactEnd ) )./EMGSampHz;
    
    
                                                    %Normalize time such that time at end of trial = 1
                                                    TimeVector_SthHop_OffsetToGContactEnd_Normalizedto1 = TimeVector_SthHop_OffsetToGContactEnd./ max(TimeVector_SthHop_OffsetToGContactEnd);
        
                                                    %Find cumulative sum of integrated EMG
                                                    MuscleQ_IntegratedEMG_OffsetToGContactEnd_CumSum = cumsum( MuscleQ_IntegratedEMG_Offset1ToGContactEnd( 1 : numel( RectifiedEMG_Offset1ToGContactEnd ) , s ) );
        
                                                    %Normalize EMG such that final summed value = 1
                                                    MuscleQ_IntegratedEMG_CumSum_Normalized_OffsetToGContactEnd =...
                                                        MuscleQ_IntegratedEMG_OffsetToGContactEnd_CumSum ./ MuscleQ_IntegratedEMG_OffsetToGContactEnd_CumSum( numel( RectifiedEMG_Offset1ToGContactEnd ) );
        
                                                    %Create reference line vectors for the x and y-axes. Will use
                                                    %y-axis in actual calculation but use x-axis for plotting only
                                                    ReferenceLine_OffsetToGContactEnd_XAxis = linspace( 0, 1, numel( RectifiedEMG_Offset1ToGContactEnd ) );
        
                                                    ReferenceLine_OffsetToGContactEnd_YAxis = linspace( 0, 1, numel( RectifiedEMG_Offset1ToGContactEnd ) );
        
                                                    %Find difference between reference line Y values and
                                                    %cumulative sum vector for integrated EMG. Positive value =
                                                    %reference line greater than integrated EMG
                                                    MuscleQ_DifferencefromReferenceLine_OffsetToGContactEnd = ReferenceLine_OffsetToGContactEnd_YAxis' - MuscleQ_IntegratedEMG_CumSum_Normalized_OffsetToGContactEnd;
        
                                                    %Find the maximum difference between the reference line and
                                                    %integrated EMG values
                                                    MaxDifferencefromReferenceLine_OffsetToGContactEnd = max(MuscleQ_DifferencefromReferenceLine_OffsetToGContactEnd);
        
        
        
                                                     %In some cases, the muscle might already be activated at the
                                                    %beginning of flight phase. This would result in the maximum
                                                    %difference between the reference line and integrated EMG
                                                    %being equal to 0. In this case, save the first frame as the frame number
                                                    %corresponding to activation onset equal. This is the "if"
                                                    %portion of the loop. In the "else" portion, will find the
                                                    %frame number corresponding to the max difference between
                                                    %reference line and integrated EMG. This is considered the
                                                    %frame number of activation onset.
                                                    if MaxDifferencefromReferenceLine_OffsetToGContactEnd == 0
        
                                                        FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) = NaN;
    
                                                    elseif sum( MuscleQ_DifferencefromReferenceLine_OffsetToGContactEnd > 0 ) < 38
    
                                                        FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) = numel( MuscleQ_DifferencefromReferenceLine_OffsetToGContactEnd );
        
                                                    else
        
                                                        FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) = find( MuscleQ_DifferencefromReferenceLine_OffsetToGContactEnd == MaxDifferencefromReferenceLine_OffsetToGContactEnd );
        
                                                    end
        
        
                                                    %Convert frame number into seconds, to find time point of
                                                    %activation onset.
                                                    TimePoint_MaxDifferencefromReferenceLine_OffsetToGContactEnd( s ) = FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) ./ EMGSampHz;
        
                                                    %Pre-activation onset is how early muscle activates relative
                                                    %to onset of ground contact phase. Therefore, need to
                                                    %subtract the time point of activation onset (from the step
                                                    %above) from the time point of ground contact onset - this
                                                    %is our pre-activation onset.
                                                    FrameNumber_SecondOnsetToGContactEnd_EntireHop(s) = FrameofMuscleOffset_EntireHop_EMGSampHz( s ) + FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s);
        
                                                    %Find the time, in seconds, of pre-activation onset
                                                    TimePoint_SecondOnsetToGContactEnd(s) = FrameNumber_SecondOnsetToGContactEnd_EntireHop(s) ./ EMGSampHz;
        
        
                                                    %Want to find the frame within the normalized time vector
                                                    %that corresponds to activation onset. Will use this
                                                    %when creating a plot to show the calculation method. If
                                                    %FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s)
                                                    %is not a NaN, can find the frame within the normalized
                                                    %time vector.
                                                    if ~isnan( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) )
    
                                                        PreactivationOnset_NormalizedTime_SecondOnsetToGContactEnd =  TimeVector_SthHop_OffsetToGContactEnd_Normalizedto1( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) );
    
                                                    %If
                                                    %FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s)
                                                    %is a NaN, set
                                                    %PreactivationOnset_NormalizedTime_SecondOnsetToGContactEnd
                                                    %to NaN
                                                    else
    
                                                        PreactivationOnset_NormalizedTime_SecondOnsetToGContactEnd =  NaN;
    
                                                    end
    
    
    
    
    
    
    
                                                    %Execute the code below if there is no second burst of
                                                    %muscle activation. Cut the EMG after the muscle
                                                    %de-activates
                                                    if FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) == 1
    
                                                        %Find the number of frames for the duration of muscle
                                                        %activation
                                                        NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
            
            
                                                        %Create matrices of muscle EMG containing only the periods in
                                                        %which the muscle is active
                                                        MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                        MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                        MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                        MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );

                                                        MuscleQ_Rectified_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Normalized_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
                                                        MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
    
                                                     %Execute the code below if the second burst of
                                                     %muscle activation occurs at the end of the hop. 
                                                    elseif FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) == numel( MuscleQ_DifferencefromReferenceLine_OffsetToGContactEnd )
    
                                                        %Find the number of frames for the duration of muscle
                                                        %activation, from onset to the end of hop
                                                        NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
            
            
                                                        %Create matrices of muscle EMG, ending at the end of
                                                        %the hop
                                                        MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
                                                        MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
                                                        MuscleQ_Rectified_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Normalized_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
                                                        MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) :  FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
                                                    %If
                                                    %FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd
                                                    %is a NaN, end the hop when the muscle deactivates
                                                    elseif isnan( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd( s ) )
    
    
                                                        %Find the number of frames for the duration of muscle
                                                        %activation
                                                        NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
            
            
                                                        %Create matrices of muscle EMG containing only the periods in
                                                        %which the muscle is active
                                                        MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                        MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                        MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                        MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                        MuscleQ_Rectified_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                                                        MuscleQ_Normalized_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
                                                        MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
    
    
                                                     %Execute the code below if there IS a second burst of
                                                     %muscle activation. We'll just take the EMG until the
                                                     %end of the hop
                                                    else
    
                                                       
    
                                                        %Find the number of frames for the duration of muscle
                                                        %activation, from onset to the end of hop
                                                        NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 ) );
            
            
                                                        %Create matrices of muscle EMG, ending at the end of
                                                        %the hop
                                                        MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
                                                        MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
                                                        MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
    
                                                        MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
                                                        MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
                                                        MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
    
                                                        MuscleQ_Rectified_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
                                                        MuscleQ_Normalized_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
    
                                                        MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : ( GContactEnd_FrameNumbers( s ) - 1 )  );
    
                                                    end
    
    
    
                                                 %If the muscle de-activates at the end of the hop, end the
                                                 %hop when the muscle de-activates
                                                else
    
    
                                                    %Find the number of frames for the duration of muscle
                                                    %activation
                                                    NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
        
        
                                                    %Create matrices of muscle EMG containing only the periods in
                                                    %which the muscle is active
                                                    MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                    MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                    MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                    MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                    MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                    MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                    MuscleQ_Rectified_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                    MuscleQ_Normalized_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                    MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                    
    
                                                end

    
    
    %% Create Indexing Variables, from Onset to Offset
    
        
                                        FrameofGContactBegin_Onset2Offset( s ) = FrameNumber_OnsetBeforeGContactBegin_FlightOnly( s ) + 1;
                                        FramesofGContactPhase = FrameofGContactBegin_Onset2Offset( s ) : NumberofFrames_OnsettoOffset( s );
                                        LengthofGroundContactPhase_Onset2Offset_Frames( s ) = numel( FramesofGContactPhase );
        
                                        FramesofBrakingPhase = FrameofGContactBegin_Onset2Offset( s ) : ( FrameofGContactBegin_Onset2Offset( s ) + FrameofBrakingPhaseEnd_EMGSampHz( s ) );
                                        LengthofBrakingPhase_Onset2Offset_Frames( s ) = numel( FramesofBrakingPhase );
                                        FrameofBrakingPhaseBegin_Onset2Offset( s ) = FrameofGContactBegin_Onset2Offset( s );
                                        FrameofBrakingPhaseEnd_Onset2Offset( s ) = FramesofBrakingPhase( numel( FramesofBrakingPhase ) );
        
                                        FramesofPropulsionPhase = ( FrameofBrakingPhaseEnd_Onset2Offset( s ) + 1 ) : NumberofFrames_OnsettoOffset( s );
                                        LengthofPropulsionPhase_Onset2Offset_Frames( s ) = numel( FramesofPropulsionPhase );
                                        FrameofPropulsionPhaseBegin_Onset2Offset( s ) = FrameofBrakingPhaseEnd_Onset2Offset( s )+1;
                                        FrameofPropulsionPhaseEnd_Onset2Offset( s ) = NumberofFrames_OnsettoOffset( s );
    
    
    
    
    
    %% Pre-activation Onset Plot - Illustration of Method - Flight Phase Only             
    
                                                %Plot the integrated EMG, reference line, and time of
                                                %activation onset.
                                                
                                                %Only show the figure below if we told the code to show all preactivation figures
                                                %for Participant N
                                                if  strcmp( cell2mat( ShowPreactivationPlots_Cell ), 'Yes' )
    
                                                    if isempty( f10 )
    
                                                        f10 = figure( 'Color', '#F5F5DC','Position', [37 79 623 621], 'Name','Illustration of Pre-activation Onset Method - Only Use Flight Phase Data' );
    
                                                    else
    
                                                        figure( f10 )
    
                                                    end
                                                        
                                                        subplot( 3, 1, 1)
                                                        plot( ReferenceLine_FlightOnly_XAxis', ReferenceLine_FlightOnly_YAxis', 'LineWidth', 2, 'Color' , 'r' )
                                                        hold on
                                                        plot( TimeVector_SthHop_FlightOnly_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly, 'LineWidth', 2, 'Color', '#0072BD' )
                                                        L_Preactivation = line( [ PreactivationOnset_NormalizedTime_FlightOnly, PreactivationOnset_NormalizedTime_FlightOnly ],...
                                                            [ MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s)),...
                                                            ReferenceLine_FlightOnly_YAxis(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s))  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
                                                        set(gca,'FontSize',14)
                                                        title('Depiction of Pre-Activation Onset Calculation','FontSize',20)
                                                        xlabel('Time (Normalized to Final Value; Max = 1)','FontSize',18)
                                                        ylabel('Integrated EMG (Normalized to Final Value; Max = 1)','FontSize',18)
                                                        
    
                                                        % Adds text to plot to show what the activation onset time
                                                        % was.
                                                        text(PreactivationOnset_NormalizedTime_FlightOnly, ReferenceLine_FlightOnly_YAxis(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s)) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_FlightOnly(s)) ], 'FontSize', 12)
                                                        hold off
    
                                                        X2 = subplot( 3, 1, 2);
                                                        plot( MuscleQ_Rectified_30HzBandpass( FramesToUse_FlightPhaseOnly ), 'LineWidth', 2 )
                                                        L_Preactivation= line( [ FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s), FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                            [ 0, max( MuscleQ_Rectified_30HzBandpass )  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
                                                        xlim( [ 0, numel( FramesToUse_FlightPhaseOnly ) ] )
                                                        set(gca,'FontSize',14)
                                                        title('Rectified EMG with Pre-Activation Onset Time','FontSize',20)
                                                        xlabel('Frame Number)','FontSize',18)
                                                        ylabel('Activation Amplitude (mV)','FontSize',18)
    
                                                        X3 = subplot( 3, 1, 3);
                                                        plot( MuscleQ_DifferencefromReferenceLine_FlightOnly, 'LineWidth', 2 )

                                                        L_Preactivation= line( [ FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s), FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                            [ min( MuscleQ_DifferencefromReferenceLine_FlightOnly ), max( MuscleQ_DifferencefromReferenceLine_FlightOnly )  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;

                                                        L_MaxDifference = line( [ 0, numel( MuscleQ_DifferencefromReferenceLine_FlightOnly ) ], [ max( MuscleQ_DifferencefromReferenceLine_FlightOnly ), max( MuscleQ_DifferencefromReferenceLine_FlightOnly ) ] );
                                                        L_MaxDifference.Color = 'r';
                                                        L_MaxDifference.LineStyle = '--';
                                                        L_MaxDifference.LineWidth = 0.5;

                                                        xlim( [ 0, numel( MuscleQ_DifferencefromReferenceLine_FlightOnly ) ] )
                                                        set(gca,'FontSize',14)
                                                        title('Difference Between Reference Line and Integrated EMG Trace','FontSize',20)
                                                        xlabel('Frame Number)','FontSize',18)
                                                        ylabel('Difference (unitless)','FontSize',18)
    
                                                        linkaxes( [ X2, X3 ], 'x' )
    
                                                        pause
    
    
    
    %% Pre-activation Onset Plot - Illustration of Method Entire Hop Cycle                                            
    
    
                                                     %Plot the integrated EMG, reference line, and time of
                                                     %activation onset.
                                                        if isempty( f11 )
                                                            
                                                            f11 = figure( 'Color', '#F5F5DC','Position', [37 79 623 621], 'Name','Illustration of Pre-activation Onset Method - Use Entire Hop Cycle Data');
                                                        
                                                        else
    
                                                            figure( f11 )
    
                                                        end
    
                                                        subplot( 3, 1, 1 )
                                                        plot( ReferenceLine_EntireHop_XAxis', ReferenceLine_EntireHop_YAxis', 'LineWidth', 2, 'Color' , 'r' )
                                                        hold on
                                                        plot( TimeVector_SthHop_EntireHop_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop, 'LineWidth', 2, 'Color', '#0072BD' )
                                                        L_Preactivation = line( [ PreactivationOnset_NormalizedTime_EntireHop, PreactivationOnset_NormalizedTime_EntireHop ],...
                                                            [ MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s)),...
                                                            ReferenceLine_EntireHop_YAxis(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s))  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
    
                                                        % Adds text to plot to show what the activation onset time
                                                        % was.
                                                        text(PreactivationOnset_NormalizedTime_EntireHop, ReferenceLine_EntireHop_YAxis(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s)) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_EntireHop(s)) ], 'FontSize', 12)
                                                        hold off
                                                        set(gca,'FontSize',14)
                                                        title('Depiction of Pre-Activation Onset Calculation','FontSize',20)
                                                        xlabel('Time (Normalized to Final Value; Max = 1)','FontSize',18)
                                                        ylabel('Integrated EMG (Normalized to Final Value; Max = 1)','FontSize',18)
    
                                                        
    
                                                        X2 = subplot( 3, 1, 2);
                                                        plot( MuscleQ_Rectified_30HzBandpass( FramesforEntireHop ), 'LineWidth', 2 )
                                                        L_Preactivation= line( [ FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s), FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s) ],...
                                                            [ 0, max( MuscleQ_Rectified_30HzBandpass )  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
                                                        xlim( [ 0, numel( FramesforEntireHop ) ] )
    
                                                        L_BeginGContact = line( [ ( numel( FramesToUse_FlightPhaseOnly ) + 1 ), ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) ],...
                                                            [ 0, max( MuscleQ_Rectified_30HzBandpass )  ] );
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;
    
                                                        xlim( [ 0, numel( FramesforEntireHop ) ] )
                                                        set(gca,'FontSize',14)
                                                        title('Rectified EMG with Pre-Activation Onset Time','FontSize',20)
                                                        xlabel('Frame Number)','FontSize',18)
                                                        ylabel('Activation Amplitude (mV)','FontSize',18)
    
    
    
    
                                                       X3 = subplot( 3, 1, 3);
                                                        plot( MuscleQ_DifferencefromReferenceLine_EntireHop, 'LineWidth', 2 )
                                                        L_Preactivation= line( [ FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s), FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s) ],...
                                                            [ min( MuscleQ_DifferencefromReferenceLine_EntireHop ), max( MuscleQ_DifferencefromReferenceLine_EntireHop )  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
                                                        xlim( [ 0, numel( MuscleQ_DifferencefromReferenceLine_EntireHop ) ] )
    
                                                        L_BeginGContact = line( [ ( numel( FramesToUse_FlightPhaseOnly ) + 1 ), ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) ],...
                                                            [ min( MuscleQ_DifferencefromReferenceLine_EntireHop ), max( MuscleQ_DifferencefromReferenceLine_EntireHop )  ] );
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;

                                                        L_MaxDifference = line( [ 0, numel( MuscleQ_DifferencefromReferenceLine_EntireHop ) ], [ max( MuscleQ_DifferencefromReferenceLine_EntireHop ), max( MuscleQ_DifferencefromReferenceLine_EntireHop ) ] );
                                                        L_MaxDifference.Color = 'r';
                                                        L_MaxDifference.LineStyle = '--';
                                                        L_MaxDifference.LineWidth = 0.5;

                                                        xlim( [ 0, numel( FramesforEntireHop ) ] )
                                                        set(gca,'FontSize',14)
                                                        title('Difference Between Reference Line and Integrated EMG Trace','FontSize',20)
                                                        xlabel('Frame Number)','FontSize',18)
                                                        ylabel('Difference (unitless)','FontSize',18)
    
                                                        linkaxes( [ X2, X3 ], 'x' )
    
                                                        pause
    
    
    
    
    
    
    %% Muscle Offset Plot - Illustration of Method                                    
    
    
                                                     %Plot the integrated EMG, reference line, and time of
                                                     %activation onset.
                                                        if isempty( f12 )
    
                                                            f12 = figure('Color', '#F5F5DC','Position', [37 79 623 621], 'Name','Illustration of Pre-activation Offset Method');
    
                                                        else
    
                                                            figure( f12 )
    
                                                        end
    
                                                        subplot( 3, 1, 1 )
                                                        plot( ReferenceLine_MuscleOffset_XAxis', ReferenceLine_MuscleOffset_YAxis', 'LineWidth', 2, 'Color' , 'r' )
                                                        hold on
                                                        plot( TimeVector_SthHop_MuscleOffset_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_MuscleOffset, 'LineWidth', 2, 'Color', '#0072BD' )
                                                        L_Preactivation = line( [ NormalizedTime_MuscleOffset, NormalizedTime_MuscleOffset ],...
                                                            [ MuscleQ_IntegratedEMG_CumSum_Normalized_MuscleOffset(FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s)),...
                                                            ReferenceLine_MuscleOffset_YAxis(FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s))  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
    
                                                        % Adds text to plot to show what the activation onset time
                                                        % was.
                                                        text(NormalizedTime_MuscleOffset, ReferenceLine_MuscleOffset_YAxis(FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s)) + 0.1, [' Muscle Deactivation =  ' num2str( TimeofMuscleOffset_EntireHop(s) ) ], 'FontSize', 12)
                                                        hold off
                                                        set(gca,'FontSize',14)
                                                        title('Depiction of Muscle Offset Timing Calculation','FontSize',20)
                                                        xlabel('Time (Normalized to Final Value; Max = 1)','FontSize',18)
                                                        ylabel('Integrated EMG (Normalized to Final Value; Max = 1)','FontSize',18)
    
    
                                                        X2 = subplot( 3, 1, 2);
                                                        plot( MuscleQ_Rectified_30HzBandpass( FramesToUse_OnsetToGContactEnd ), 'LineWidth', 2 )
                                                        L_Preactivation= line( [ FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s), FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) ],...
                                                            [ 0, max( MuscleQ_Rectified_30HzBandpass )  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
                                                        xlim( [ 0, numel( FramesToUse_OnsetToGContactEnd ) ] )
                                                        set(gca,'FontSize',14)
                                                        title('Rectified EMG with Muscle Offset Timing','FontSize',20)
                                                        xlabel('Frame Number)','FontSize',18)
                                                        ylabel('Activation Amplitude (mV)','FontSize',18)
    
                                                        X3 = subplot( 3, 1, 3);
                                                        plot( MuscleQ_DifferencefromReferenceLine_MuscleOffset, 'LineWidth', 2 )
                                                        L_Preactivation= line( [ FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s), FrameNumber_MinDifferencefromReferenceLine_MuscleOffset(s) ],...
                                                            [ min( MuscleQ_DifferencefromReferenceLine_MuscleOffset ), max( MuscleQ_DifferencefromReferenceLine_MuscleOffset )  ] );
                                                        L_Preactivation.Color = '#7E2F8E';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;

                                                        L_MaxDifference = line( [ 0, numel( MuscleQ_DifferencefromReferenceLine_MuscleOffset ) ], [ min( MuscleQ_DifferencefromReferenceLine_MuscleOffset ), min( MuscleQ_DifferencefromReferenceLine_MuscleOffset ) ] );
                                                        L_MaxDifference.Color = 'r';
                                                        L_MaxDifference.LineStyle = '--';
                                                        L_MaxDifference.LineWidth = 2;

                                                        xlim( [ 0, numel( MuscleQ_DifferencefromReferenceLine_MuscleOffset ) ] )
                                                        set(gca,'FontSize',14)
                                                        title('Difference Between Reference Line and Integrated EMG Trace','FontSize',20)
                                                        xlabel('Frame Number)','FontSize',18)
                                                        ylabel('Difference (unitless)','FontSize',18)
    
                                                        linkaxes( [ X2, X3 ], 'x' )
    
                                                        pause
    
    
    
    
    
    %% Plot Rectified Muscle Activation
    

                                                        %If f1 is empty, assign a figure to it. Otherwise,
                                                        %just call f1 again. This avoids creation of a
                                                        %completely new figure window every iteration
                                                        if isempty( f1 )
        
                                                            f1 = figure( 'Name', [ 'Rectified EMG, ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ]  );
            
                                                        else
    
                                                            figure( f1 );
    
                                                        end
                                                             
                                                             plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated(1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ),s), 'LineWidth', 2, 'Color' , 'k' )
            
                                                            hold on
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            title( [ 'Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
            
                                                             hold off
            
                                                             pause
        
    
    
    
    %% Plot Rectified Muscle Activation WITH ONSET/OFFSET LINES - SD Threshold Method
        
                                                                
                                                         %Store the ankle angle for the entire hop in a new variable
                                                        AnkleAngle_EntireSthHop = AnkleSagittalAngle( AllFrames_SthHop_MoCap, s );
                                                        
                                                                                                
                                                        %Store the ankle angle for the flight phase in a new variable
                                                        AnkleAngle_FlightPhaseSthHop = AnkleSagittalAngle( FlightPhaseFrames_SthHop_MoCap, s );


                                                        %If f7 is empty, assign a figure to it. Otherwise,
                                                        %just call f7 again. This avoids creation of a
                                                        %completely new figure window every iteration
                                                        if isempty( f7 )
        
                                                            f7 = figure( 'Position', [37 79 623 621], 'Name', [ 'Rectified EMG with Muscle Onset/Offset Lines - SD Threshold Method,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ]  );
            
                                                        else
    
                                                            figure( f7 );
    
                                                        end

                                                        %Set title for entire plot
                                                        sgtitle( [ 'Rectified EMG with Muscle Onset/Offset Lines - SD Threshold Method,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ] )

                                                        %Subplot 1 - Ankle Angle
                                                        X1 = subplot( 3, 1, 1 );
                                                        plot( AllFrames_SthHop_MoCap./MoCapSampHz, AnkleAngle_EntireSthHop, 'LineWidth', 2, 'Color' , 'k' )

                                                        hold on
        
                                                        
                                                        L_Preactivation_IndividualHopBaseline = line( [ TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s), TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s) ],...
                                                            [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L_Preactivation_IndividualHopBaseline.Color = 'm';
                                                        L_Preactivation_IndividualHopBaseline.LineStyle = '-';
                                                        L_Preactivation_IndividualHopBaseline.LineWidth = 2;
                
        
                                                        L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                            [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
        
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;


                                                        xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                        ylim( [ min( min( AnkleSagittalAngle ) ) - 5, max( max( AnkleSagittalAngle ) ) + 5 ] )

                                                        legend('Ankle Angle','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                        title( [ 'Ankle Angle, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                        xlabel('Time (s)')
                                                        ylabel( string_Angle )

                                                        hold off


                                                        %Subplot 2 - TA EMG
                                                        X2 = subplot( 3, 1, 2 );

                                                        if q ~= 5

                                                            plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, TATrialP_HopS, 'LineWidth', 2, 'Color' , 'b' )

                                                        end

                                                        hold on
        
                                                        
                                                        L_Preactivation_IndividualHopBaseline = line( [ TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s), TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s) ],...
                                                            [ -30, max( max( TATrialP ) ) ] );
                                                        L_Preactivation_IndividualHopBaseline.Color = 'm';
                                                        L_Preactivation_IndividualHopBaseline.LineStyle = '-';
                                                        L_Preactivation_IndividualHopBaseline.LineWidth = 2;
                
        
                                                        L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                            [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
        
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;


                                                        xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                        ylim( [ -30, max( max( TATrialP ) ) + 50 ] )

                                                        legend('EMG','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                        title( [ 'Rectified TA EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                        xlabel('Time (s)')
                                                        ylabel( RawHoppingUnits_string )

                                                        hold off

                                                        
                                                        %Subplot 3 - Muscle Q EMG
                                                        X3 = subplot( 3, 1, 3 ); %#ok<*NASGU>
                                                         plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated(1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ),s), 'LineWidth', 2, 'Color' , 'k' )
        
                                                        hold on

        
                                                        L_Preactivation_RestingEMG = line( [ TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop(s), TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop(s) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L_Preactivation_RestingEMG.Color = '#54278f';
                                                        L_Preactivation_RestingEMG.LineStyle = '-';
                                                        L_Preactivation_RestingEMG.LineWidth = 2;
        
                                                        
                                                        L_Preactivation_IndividualHopBaseline = line( [ TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s), TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L_Preactivation_IndividualHopBaseline.Color = 'm';
                                                        L_Preactivation_IndividualHopBaseline.LineStyle = '-';
                                                        L_Preactivation_IndividualHopBaseline.LineWidth = 2;
        
        
                                                        L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
        
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;
    
                                                        legend('Rectified EMG', 'Pre-activation, SD Threshold - Resting EMG Baseline', 'Pre-activation, SD Threshold - Individual Hop Baseline',...
                                                            'GContact Begin','location','northeast')

                                                        xlabel('Time (s)')
                                                        ylabel( RawHoppingUnits_string )
                                                        title( ['Rectified ', MuscleID{q}, ' EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                        xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
        
                                                         hold off

                                                         linkaxes( [X1, X2, X3], 'x' )
                                                         
                                                         savefig( f7, [ ParticipantList{ n }, '_', 'PlotRectifiedEMGwithMuscleOnsetOffsetLines-SDThresholdMethod', '_', LimbID{ a }, '_', MuscleID{q}, '_' HoppingRate_ID{ b }, 'Hop', num2str( s ), '.fig' ] );
        
                                                         pause
    
    
    
    
    
    %% Plot Rectified Muscle Activation WITH ONSET/OFFSET LINES - Santello McDonagh Method
        
                                                        %If f2 is empty, assign a figure to it. Otherwise,
                                                        %just call f2 again. This avoids creation of a
                                                        %completely new figure window every iteration
                                                        if isempty( f2 )
        
                                                            f2 = figure( 'Position', [37 79 623 621], 'Name', [ 'Rectified EMG with Muscle Onset/Offset Lines - Santello McDonagh,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ]  );
            
                                                        else
    
                                                            figure( f2 );
    
                                                        end

                                                        %Set title for entire plot
                                                        sgtitle( [ 'Rectified EMG with Muscle Onset/Offset Lines - SD Threshold Method,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ] )


                                                        X1 = subplot( 3, 1, 1 );
                                                        plot( AllFrames_SthHop_MoCap./MoCapSampHz, AnkleAngle_EntireSthHop, 'LineWidth', 2, 'Color' , 'k' )

                                                        hold on
        
                                                        
                                                        L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                             [ -30, max( max( TATrialP ) ) ] );
                                                        L_Preactivation.Color = '#a50026';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
                
        
                                                        L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                            [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
        
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;

                                                        xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )                                          
                                                        ylim( [ min( min( AnkleSagittalAngle ) ) - 5, max( max( AnkleSagittalAngle ) ) + 5 ] )

                                                        legend('Ankle Angle','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                        title( [ 'Ankle Angle, ', 'Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                        xlabel('Time (s)')
                                                        ylabel( string_Angle )

                                                        hold off


                                                        %Subplot 2 - TA EMG
                                                        X2 = subplot( 3, 1, 2 );

                                                        if q ~= 5

                                                            plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, TATrialP_HopS, 'LineWidth', 2, 'Color' , 'b' )

                                                        end

                                                        hold on
        
                                                        
                                                        L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                             [ -30, max( max( TATrialP ) ) ] );
                                                        L_Preactivation.Color = '#a50026';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
                
        
                                                        L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                            [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
        
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;


                                                        xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                        ylim( [ -30, max( max( TATrialP ) ) + 50 ] )

                                                        legend('EMG','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                        title( [ 'Rectified TA EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                        xlabel('Time (s)')
                                                        ylabel( RawHoppingUnits_string )

                                                        hold off


                                                        X3 = subplot( 3, 1, 3 );
                                                         plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated(1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ),s), 'LineWidth', 2, 'Color' , 'k' )
        
                                                        hold on
        
        
                                                        L_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase( s ), TimeofMuscleOffset_FlightPhase( s ) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L_FlightOffset.Color = '#74add1';
                                                        L_FlightOffset.LineStyle = '--';
                                                        L_FlightOffset.LineWidth = 2;
        
        
                                                        L2_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase_DoubleCheck( s ), TimeofMuscleOffset_FlightPhase_DoubleCheck( s ) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L2_FlightOffset.Color = '#74add1';
                                                        L2_FlightOffset.LineStyle = '-.';
                                                        L2_FlightOffset.LineWidth = 2;
        
        
                                                        L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L_Preactivation.Color = '#a50026';
                                                        L_Preactivation.LineStyle = '-';
                                                        L_Preactivation.LineWidth = 2;
        
                                                        
                                                        L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L2_Preactivation.Color = '#d73027';
                                                        L2_Preactivation.LineStyle = '--';
                                                        L2_Preactivation.LineWidth = 2;
        
                                                        
                                                        L3_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ), TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L3_Preactivation.Color = '#d73027';
                                                        L3_Preactivation.LineStyle = '-.';
                                                        L3_Preactivation.LineWidth = 2;
        
        
                                                        L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L_Offset.Color = '#313695';
                                                        L_Offset.LineStyle = '-.';
                                                        L_Offset.LineWidth = 2;
        
        
                                                        L2_Offset = line( [ TimeofMuscleOffset_EntireHop_DoubleCheck( s ), TimeofMuscleOffset_EntireHop_DoubleCheck( s ) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L2_Offset.Color = '#313695';
                                                        L2_Offset.LineStyle = '--';
                                                        L2_Offset.LineWidth = 2;
        
        
        
                                                        L3_Onset2 = line( [ TimePoint_SecondOnsetToGContactEnd(s), TimePoint_SecondOnsetToGContactEnd(s) ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                        L3_Onset2.Color = '#f46d43';
                                                        L3_Onset2.LineStyle = '-.';
                                                        L3_Onset2.LineWidth = 2;
                
        
                                                        L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                            [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
        
                                                        L_BeginGContact.Color = '#fdae61';
                                                        L_BeginGContact.LineStyle = '-';
                                                        L_BeginGContact.LineWidth = 2;
                
        
                                                        L_OnsetMagnitude = line( [ 1 ./ EMGSampHz, LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) ./EMGSampHz ],...
                                                            [ MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s), MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s) ] );
        
                                                        L_OnsetMagnitude.Color = 'r';
                                                        L_OnsetMagnitude.LineStyle = '--';
                                                        L_OnsetMagnitude.LineWidth = 1;
    
                                                        legend('Rectified EMG','Flight Phase Offset', 'Flight Phase Offset Doublecheck', 'Pre-activation, Flight Only', 'Pre-activation, Entire Hop',...
                                                            'Pre-activation, Entire Hop, Time Threshold', 'Offset','Offset Doublecheck', 'Second Onset', 'GContact Begin','100 mv Threshold','location','northeast')
    
                                                        xlabel('Time (s)')
                                                        ylabel( RawHoppingUnits_string )
                                                        title( ['Rectified ', MuscleID{q}, ' EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                        xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
        
                                                         hold off

                                                         linkaxes( [X1, X2, X3], 'x' )
                                                         
                                                         savefig( [ ParticipantList{ n }, '_', 'Plot Rectified EMG with Muscle OnsetOffset Lines - Santello McDonagh', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, 'Hop ', num2str( s ), '.fig' ] );
        
                                                         pause
        
        %                                                  subplot( 3, 1, 2 )
        % 
        %                                                 plot( ReferenceLine_FlightOnly_XAxis', ReferenceLine_FlightOnly_YAxis', 'LineWidth', 2, 'Color' , '#54278f' )
        %                                                 hold on
        %                                                 plot( TimeVector_SthHop_FlightOnly_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly, 'LineWidth', 2, 'Color', '#0072BD' )
        %                                                 L_Preactivation = line( [ PreactivationOnset_NormalizedTime_FlightOnly, PreactivationOnset_NormalizedTime_FlightOnly ],...
        %                                                     [ MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s)),...
        %                                                     ReferenceLine_FlightOnly_YAxis(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s))  ] );
        %                                                 L_Preactivation.Color = '#7E2F8E';
        %                                                 L_Preactivation.LineStyle = '-';
        %                                                 L_Preactivation.LineWidth = 2;
        %         
        %                                                 % Adds text to plot to show what the activation onset time
        %                                                 % was.
        %                                                 text(PreactivationOnset_NormalizedTime_FlightOnly, ReferenceLine_FlightOnly_YAxis(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s)) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_FlightOnly(s)) ], 'FontSize', 12)
        %                                                 hold off
        % 
        % 
        % 
        %                                                 subplot( 3, 1, 3 )
        %                                                 plot( ReferenceLine_EntireHop_XAxis', ReferenceLine_EntireHop_YAxis', 'LineWidth', 2, 'Color' , '#54278f' )
        %                                                 hold on
        %                                                 plot( TimeVector_SthHop_EntireHop_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop, 'LineWidth', 2, 'Color', '#0072BD' )
        %                                                 L_Preactivation = line( [ PreactivationOnset_NormalizedTime_EntireHop, PreactivationOnset_NormalizedTime_EntireHop ],...
        %                                                     [ MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s)),...
        %                                                     ReferenceLine_EntireHop_YAxis(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s))  ] );
        %                                                 L_Preactivation.Color = '#7E2F8E';
        %                                                 L_Preactivation.LineStyle = '-';
        %                                                 L_Preactivation.LineWidth = 2;
        %         
        %                                                 % Adds text to plot to show what the activation onset time
        %                                                 % was.
        %                                                 text(PreactivationOnset_NormalizedTime_EntireHop, ReferenceLine_EntireHop_YAxis(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s)) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_EntireHop(s)) ], 'FontSize', 12)
        %                                                 hold off
        
            
            
        
                                                        
        %                                                     figure('Name','Illustration of Second Burst Onset Detection')
        %                                                     plot( ReferenceLine_OffsetToGContactEnd_XAxis', ReferenceLine_OffsetToGContactEnd_YAxis', 'LineWidth', 2, 'Color' , '#54278f' )
        %                                                     hold on
        %                                                     plot( TimeVector_SthHop_OffsetToGContactEnd_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_OffsetToGContactEnd, 'LineWidth', 2, 'Color', '#0072BD' )
        %                                                     L_Preactivation = line( [ PreactivationOnset_NormalizedTime_FlightOnly, PreactivationOnset_NormalizedTime_FlightOnly ],...
        %                                                         [ MuscleQ_IntegratedEMG_CumSum_Normalized_OffsetToGContactEnd( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) ),...
        %                                                         ReferenceLine_OffsetToGContactEnd_YAxis( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) )  ] );
        %                                                     L_Preactivation.Color = '#7E2F8E';
        %                                                     L_Preactivation.LineStyle = '-';
        %                                                     L_Preactivation.LineWidth = 2;
        %             
        %                                                     % Adds text to plot to show what the activation onset time
        %                                                     % was.
        %                                                     text(PreactivationOnset_NormalizedTime_OffsetToGContactEnd, ReferenceLine_OffsetToGContactEnd_YAxis( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) ) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_FlightOnly(s)) ], 'FontSize', 12)
        %                                                     hold off
        % 
        %                                                  pause
        % 
        %                                                  close
        % 
        %                                                 if s == 1
        % 
        %                                                     f13 = figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ], 'Name','Rectified EMG with Muscle Onset/Offset');
        %                                                     
        %                                                     subplot( size(MuscleQ_Rectified_IndividualHops, 2) , 1, s )
        %                                                     plot( ( 1 : LengthofHop_EMGData( s, p) )./EMGSampHz, MuscleQ_Rectified_IndividualHops(1 : LengthofHop_EMGData(s,p),s), 'LineWidth', 2, 'Color' , 'k' )
        %                                                     hold on
        % 
        %                                                     L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Preactivation.Color = '#a50026';
        %                                                     L_Preactivation.LineStyle = '-';
        %                                                     L_Preactivation.LineWidth = 2;
        % 
        %                                                     L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Offset.Color = '#54278f';
        %                                                      L_Offset.LineStyle = '-.';
        %                                                     L_Offset.LineWidth = 2;
        % 
        %                                                     L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L2_Preactivation.Color = '#54278f';
        %                                                     L2_Preactivation.LineStyle = '--';
        %                                                     L2_Preactivation.LineWidth = 2;
        % 
        %                                                     L_BeginGContact = line( [ TimeofGContact, TimeofGContact ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        % 
        %                                                     L_BeginGContact.Color = '#fdae61';
        %                                                     L_BeginGContact.LineStyle = '-';
        %                                                     L_BeginGContact.LineWidth = 2;
        %             
        %                                                      hold off
        % 
        %                                                 else
        % 
        %                                                     figure( f13 )
        % 
        %                                                     subplot( size(MuscleQ_Rectified_IndividualHops, 2) , 1, s )
        %                                                     plot( ( 1 : LengthofHop_EMGData( s, p) )./EMGSampHz, MuscleQ_Rectified_IndividualHops(1 : LengthofHop_EMGData(s,p),s), 'LineWidth', 2, 'Color' , 'k' )
        %                                                     hold on
        % 
        %                                                     L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Preactivation.Color = '#a50026';
        %                                                     L_Preactivation.LineStyle = '-';
        %                                                     L_Preactivation.LineWidth = 2;
        % 
        %                                                     L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Offset.Color = '#54278f';
        %                                                      L_Offset.LineStyle = '-.';
        %                                                     L_Offset.LineWidth = 2;
        % 
        %                                                     L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L2_Preactivation.Color = '#54278f';
        %                                                     L2_Preactivation.LineStyle = '--';
        %                                                     L2_Preactivation.LineWidth = 2;
        % 
        %                                                     L_BeginGContact = line( [ TimeofGContact, TimeofGContact ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        % 
        %                                                     L_BeginGContact.Color = '#fdae61';
        %                                                     L_BeginGContact.LineStyle = '-';
        %                                                     L_BeginGContact.LineWidth = 2;
        %             
        %                                                     hold off
        
        
        %% Plot Rectified Muscle Activation - From Onset To Offset
        
                                                        %If f3 is empty, assign a figure to it. Otherwise,
                                                        %just call f3 again. This avoids creation of a
                                                        %completely new figure window every iteration
                                                        if isempty( f3 )
        
                                                            f3 =  figure( 'Name', [ 'Rectified EMG from Muscle Onset to Offset,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ] );
            
                                                        else
    
                                                            figure( f3 );
    
                                                        end
                                                        
                                                        plot( ( 1 : NumberofFrames_OnsettoOffset( s ) )./EMGSampHz, MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ), 'LineWidth', 2, 'Color' , 'k' )
                                                        hold on
  
                                                        L_OnsetMagnitude = line( [ 1 ./ EMGSampHz, LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) ./EMGSampHz ],...
                                                            [ MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s), MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s) ] );
        
                                                        L_OnsetMagnitude.Color = 'r';
                                                        L_OnsetMagnitude.LineStyle = '--';
                                                        L_OnsetMagnitude.LineWidth = 1;

                                                        hold off

                                                        title( [ 'Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                        pause
                                                         
                                                         savefig( [ ParticipantList{ n }, '_', 'Plot Rectified EMG from Onset to Offset', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, 'Hop ', num2str( s ), '.fig' ] );
        
    


    %% Adjust Deactivation and Preactivation Onset if needed
    
    
    
                                                        %Create a prompt so we can manually adjust the
                                                        %muscle deactivation if needed
                                                        AdjustMusleDeactivationPrompt =  'Adjust Muscle Deactivation?' ;
                                                        
                                                        %Use inputdlg function to create a dialogue box for the prompt created above.
                                                        %First arg is prompt, 2nd is title
                                                        AdjustMusleDeactivation_Cell = inputdlg( [ '\fontsize{15}' AdjustMusleDeactivationPrompt ], 'Adjust Muscle Deactivation?', [1 150], {'No'} ,CreateStruct);
    
    
    
    
                                                        %If we said we want to adjust the muscle
                                                        %de-activation onset, use ginput to select the
                                                        %new point
                                                        if strcmp( cell2mat( AdjustMusleDeactivation_Cell ), 'Yes' ) || strcmp( cell2mat( AdjustMusleDeactivation_Cell ), 'Y' )
    
                                                             %Plot rectified muscle activation for entire hop,
                                                            %with onset and offset lines.
                                                            if isempty( f99 )
    
                                                                f99 = figure( 'Position', [37 79 623 621] );
    
                                                            else
    
                                                                figure( f99 )
    
                                                            end

                                                            %Set title for entire plot
                                                            sgtitle( [ 'Rectified EMG with Muscle Onset/Offset Lines - SD Threshold Method,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ] )
        
                                                            X1 = subplot( 3, 1, 1 );
                                                            plot( AllFrames_SthHop_MoCap./MoCapSampHz, AnkleAngle_EntireSthHop, 'LineWidth', 2, 'Color' , 'k' )
    
                                                            hold on
        
                                                        
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                 [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            hold off
    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ min( min( AnkleSagittalAngle ) ) - 5, max( max( AnkleSagittalAngle ) ) + 5 ] )
    
                                                            legend('Ankle Angle','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                            title( [ 'Ankle Angle, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( string_Angle )


                                                            %Subplot 2 - TA EMG
                                                            X2 = subplot( 3, 1, 2 );
    
                                                            if q ~= 5
    
                                                                plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, TATrialP_HopS, 'LineWidth', 2, 'Color' , 'b' )
    
                                                            end
    
                                                            hold on
                                                        
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                 [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            hold off
    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ -30, max( max( TATrialP ) ) + 50 ] )
    
                                                            legend('EMG','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                            title( [ 'Rectified TA EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
    

    
    
                                                            X3 = subplot( 3, 1, 3 );
                                                            plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated(1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ),s), 'LineWidth', 2, 'Color' , 'k' )
                                                            hold on
        
                                                            L_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase( s ), TimeofMuscleOffset_FlightPhase( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_FlightOffset.Color = '#74add1';
                                                            L_FlightOffset.LineStyle = '--';
                                                            L_FlightOffset.LineWidth = 2;
            
            
                                                            L2_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase_DoubleCheck( s ), TimeofMuscleOffset_FlightPhase_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_FlightOffset.Color = '#74add1';
                                                            L2_FlightOffset.LineStyle = '-.';
                                                            L2_FlightOffset.LineWidth = 2;
            
            
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
            
                                                            
                                                            L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Preactivation.Color = '#d73027';
                                                            L2_Preactivation.LineStyle = '--';
                                                            L2_Preactivation.LineWidth = 2;
            
                                                            
                                                            L3_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ), TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Preactivation.Color = '#d73027';
                                                            L3_Preactivation.LineStyle = '-.';
                                                            L3_Preactivation.LineWidth = 2;
            
            
                                                            L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Offset.Color = '#313695';
                                                             L_Offset.LineStyle = '-.';
                                                            L_Offset.LineWidth = 2;
            
            
                                                            L2_Offset = line( [ TimeofMuscleOffset_EntireHop_DoubleCheck( s ), TimeofMuscleOffset_EntireHop_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Offset.Color = '#313695';
                                                            L2_Offset.LineStyle = '--';
                                                            L2_Offset.LineWidth = 2;
            
            
            
                                                            L3_Onset2 = line( [ TimePoint_SecondOnsetToGContactEnd(s), TimePoint_SecondOnsetToGContactEnd(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Onset2.Color = '#f46d43';
                                                            L3_Onset2.LineStyle = '-.';
                                                            L3_Onset2.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
                
        
                                                            L_OnsetMagnitude = line( [ 1 ./ EMGSampHz, LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) ./EMGSampHz ],...
                                                                [ MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s), MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s) ] );
            
                                                            L_OnsetMagnitude.Color = 'r';
                                                            L_OnsetMagnitude.LineStyle = '--';
                                                            L_OnsetMagnitude.LineWidth = 1;
    
                                                            legend('Rectified EMG','Flight Phase Offset', 'Flight Phase Offset Doublecheck', 'Pre-activation, Flight Only', 'Pre-activation, Entire Hop',...
                                                            'Pre-activation, Entire Hop, Time Threshold', 'Offset','Offset Doublecheck', 'Second Onset', 'GContact Begin', 'Onset Magnitude', 'location','north')
    

                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
                                                            title( ['Rectified ', MuscleID{q}, ' EMG, 30 Hz Bandpass' ] )
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
            
                                                             hold off

                                                            linkaxes( [X1, X2, X3], 'x' )
    
                                                             pause
    
                                                             
%                                                             %Create a prompt so we can manually adjust the
%                                                             %muscle deactivation if needed
%                                                             DeactivationBeginFramePrompt =  'Enter the Frame for Beginning Deactivation';
%                                                             
%                                                             %Use inputdlg function to create a dialogue box for the prompt created above.
%                                                             %First arg is prompt, 2nd is title
%                                                             DeactivationBeginFrame_Cell = inputdlg( [ '\fontsize{15}' DeactivationBeginFramePrompt ], 'Enter the Frame for Beginning Deactivation', [1 150], {'0'} ,CreateStruct);


    
                                                            [ NewDeactivationTime_X, NewDeactivationTime_Y ] = ginput( 1 );
    
                                                            %Adjust muscle offset frame number. X
                                                            %coordinate is in seconds, so multiply by
                                                            %sampling rate to get frame number
                                                            FrameofMuscleOffset_AfterOnset_EMGSampHz(s) = ceil( NewDeactivationTime_X .* EMGSampHz ) - FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s);
                                                            FrameofMuscleOffset_EntireHop_EMGSampHz( s ) = ceil( NewDeactivationTime_X .* EMGSampHz );
    
                                                            %Adjust frame number of deactivation onset,
                                                            %relative to entire trial (hops are not segmented
                                                            %out). Need to subtract 1 to get the correct
                                                            %number
                                                            FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) = BeginFlight_FrameNumbers( s ) + ceil( NewDeactivationTime_X .* EMGSampHz ) - 1;
    
                                                            %Find the time, in seconds, of muscle
                                                            %deactivation
                                                            TimeofMuscleOffset_EntireHop( s ) = FrameofMuscleOffset_EntireHop_EMGSampHz( s ) ./ EMGSampHz;
    
                                                            %Change the number of frames vector.
                                                            NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
    
                                                            %Create matrices of muscle EMG containing only the periods in
                                                            %which the muscle is active. First, set all
                                                            %frames for the current column of each matrix to
                                                            %NaN.
                                                            MuscleQ_Rectified_10HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Normalized_10HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
    
                                                            MuscleQ_Rectified_30HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Normalized_30HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Rectified_NoBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
                                                            
                                                            MuscleQ_Normalized_NoBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Normalized_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );

            
                                                            MuscleQ_Rectified4Coherence_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            
    
    
                                                            %Plot rectified muscle activation for entire hop,
                                                            %with onset and offset lines.
                                                             figure( f2 );

                                                            %Set title for entire plot
                                                            sgtitle( [ 'Rectified EMG with Muscle Onset/Offset Lines - SD Threshold Method,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ] )
        

                                                            X1 = subplot( 3, 1, 1 );
                                                            plot( AllFrames_SthHop_MoCap./MoCapSampHz, AnkleAngle_EntireSthHop, 'LineWidth', 2, 'Color' , 'k' )
    
                                                            hold on
                                                        
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                 [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ min( min( AnkleSagittalAngle ) ) - 5, max( max( AnkleSagittalAngle ) ) + 5 ] )
    
                                                            legend('Ankle Angle','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                            title( [ 'Ankle Angle, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( string_Angle )
    
                                                            hold off


                                                            %Subplot 2 - TA EMG
                                                            X2 = subplot( 3, 1, 2 );
    
                                                            if q ~= 5
    
                                                                plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, TATrialP_HopS, 'LineWidth', 2, 'Color' , 'b' )
    
                                                            end
    
                                                            hold on
                                                        
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                 [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ -30, max( max( TATrialP ) ) + 50 ] )
    
                                                            legend('EMG','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                            title( [ 'Rectified TA EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
    
                                                            hold off



                                                            X3 = subplot( 3, 1, 3 );
                                                            plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated(1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ),s), 'LineWidth', 2, 'Color' , 'k' )
                                                            hold on
        
                                                            L_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase( s ), TimeofMuscleOffset_FlightPhase( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_FlightOffset.Color = '#74add1';
                                                            L_FlightOffset.LineStyle = '--';
                                                            L_FlightOffset.LineWidth = 2;
            
            
                                                            L2_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase_DoubleCheck( s ), TimeofMuscleOffset_FlightPhase_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_FlightOffset.Color = '#74add1';
                                                            L2_FlightOffset.LineStyle = '-.';
                                                            L2_FlightOffset.LineWidth = 2;
            
            
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
            
                                                            
                                                            L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Preactivation.Color = '#d73027';
                                                            L2_Preactivation.LineStyle = '--';
                                                            L2_Preactivation.LineWidth = 2;
            
                                                            
                                                            L3_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ), TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Preactivation.Color = '#d73027';
                                                            L3_Preactivation.LineStyle = '-.';
                                                            L3_Preactivation.LineWidth = 2;
            
            
                                                            L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Offset.Color = '#313695';
                                                             L_Offset.LineStyle = '-.';
                                                            L_Offset.LineWidth = 2;
            
            
                                                            L2_Offset = line( [ TimeofMuscleOffset_EntireHop_DoubleCheck( s ), TimeofMuscleOffset_EntireHop_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Offset.Color = '#313695';
                                                            L2_Offset.LineStyle = '--';
                                                            L2_Offset.LineWidth = 2;
            
            
            
                                                            L3_Onset2 = line( [ TimePoint_SecondOnsetToGContactEnd(s), TimePoint_SecondOnsetToGContactEnd(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Onset2.Color = '#f46d43';
                                                            L3_Onset2.LineStyle = '-.';
                                                            L3_Onset2.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
                
        
                                                            L_OnsetMagnitude = line( [ 1 ./ EMGSampHz, LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) ./EMGSampHz ],...
                                                                [ MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s), MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated( ceil( TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) .* EMGSampHz) ,s) ] );
            
                                                            L_OnsetMagnitude.Color = 'r';
                                                            L_OnsetMagnitude.LineStyle = '--';
                                                            L_OnsetMagnitude.LineWidth = 1;
    
                                                            legend('Rectified EMG','Flight Phase Offset', 'Flight Phase Offset Doublecheck', 'Pre-activation, Flight Only', 'Pre-activation, Entire Hop',...
                                                            'Pre-activation, Entire Hop, Time Threshold', 'Offset','Offset Doublecheck', 'Second Onset', 'GContact Begin', 'Onset Magnitude', 'location','north')
    

                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
                                                            title( ['Rectified ', MuscleID{q}, ' EMG, 30 Hz Bandpass' ] )
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
            
                                                             hold off

                                                            linkaxes( [X1, X2, X3], 'x' )
                                                         
                                                            savefig( [ ParticipantList{ n }, '_', 'Plot Rectified EMG with Muscle OnsetOffset Lines - Santello McDonagh', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, 'Hop ', num2str( s ), '.fig' ] );
            
                                                             pause
        
    
    
        
                                                            % Plot Rectified Muscle Activation - Onset to Offset    
                                                            
                                                            figure( f3 );
                                                            plot( ( 1 : NumberofFrames_OnsettoOffset( s ) )./EMGSampHz, MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ), 'LineWidth', 2, 'Color' , 'k' )
    
                                                            title( [ 'Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
                                                         
                                                            savefig( [ ParticipantList{ n }, '_', 'Plot Rectified EMG from Onset to Offset', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, 'Hop ', num2str( s ), '.fig' ] );

                                                            pause
    
    
                                                        end
    
    
    
    
                                                        %Create a prompt so we can manually adjust the
                                                        %preactivation onset if needed
                                                        AdjustPreactivationOnsetPrompt =  'Adjust Preactivation Onset?' ;
                                                        
                                                        %Use inputdlg function to create a dialogue box for the prompt created above.
                                                        %First arg is prompt, 2nd is title
                                                        AdjustPreactivationOnset_Cell = inputdlg( [ '\fontsize{15}' AdjustPreactivationOnsetPrompt ], 'Adjust Preactivation Onset?', [1 150], {'No'} ,CreateStruct);
    
    
    
                                                        %If you need to adjust the pre-activation onset
                                                        %point, use ginput to select the new point
                                                        if strcmp( cell2mat( AdjustPreactivationOnset_Cell ), 'Yes' ) || strcmp( cell2mat( AdjustPreactivationOnset_Cell ), 'Y' )
    
                                                            %Plot rectified muscle activation for entire hop,
                                                            %with onset and offset lines.
                                                            if isempty( f99 )
    
                                                                f99 = figure( 'Position', [37 79 623 621] );
    
                                                            else
    
                                                                figure( f99 )
    
                                                            end

                                                            %Set title for entire plot
                                                            sgtitle( [ 'Rectified EMG with Muscle Onset/Offset Lines - SD Threshold Method,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ] )
        
    
                                                            X1 = subplot( 3, 1, 1 );
                                                            plot( AllFrames_SthHop_MoCap./MoCapSampHz, AnkleAngle_EntireSthHop, 'LineWidth', 2, 'Color' , 'k' )
    
                                                            hold on
        
                                                        
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                 [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ min( min( AnkleSagittalAngle ) ) - 5, max( max( AnkleSagittalAngle ) ) + 5 ] )
    
                                                            legend('Ankle Angle','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')                                                            
                                                            title( [ 'Ankle Angle, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( string_Angle )
    
                                                            hold off


                                                            %Subplot 2 - TA EMG
                                                            X2 = subplot( 3, 1, 2 );
    
                                                            if q ~= 5
    
                                                                plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, TATrialP_HopS, 'LineWidth', 2, 'Color' , 'b' )
    
                                                            end
    
                                                            hold on
                                                        
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                 [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ -30, max( max( TATrialP ) ) + 50 ] )
    
                                                            legend('EMG','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                            title( [ 'Rectified TA EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
    
                                                            hold off

    
    
                                                            X3 = subplot( 3, 1, 3 );
                                                            plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated(1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ),s), 'LineWidth', 2, 'Color' , 'k' )
                                                            hold on
        
                                                            L_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase( s ), TimeofMuscleOffset_FlightPhase( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_FlightOffset.Color = '#74add1';
                                                            L_FlightOffset.LineStyle = '--';
                                                            L_FlightOffset.LineWidth = 2;
            
            
                                                            L2_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase_DoubleCheck( s ), TimeofMuscleOffset_FlightPhase_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_FlightOffset.Color = '#74add1';
                                                            L2_FlightOffset.LineStyle = '-.';
                                                            L2_FlightOffset.LineWidth = 2;
            
            
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
            
                                                            
                                                            L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Preactivation.Color = '#d73027';
                                                            L2_Preactivation.LineStyle = '--';
                                                            L2_Preactivation.LineWidth = 2;
            
                                                            
                                                            L3_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ), TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Preactivation.Color = '#d73027';
                                                            L3_Preactivation.LineStyle = '-.';
                                                            L3_Preactivation.LineWidth = 2;
            
            
                                                            L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Offset.Color = '#313695';
                                                             L_Offset.LineStyle = '-.';
                                                            L_Offset.LineWidth = 2;
            
            
                                                            L2_Offset = line( [ TimeofMuscleOffset_EntireHop_DoubleCheck( s ), TimeofMuscleOffset_EntireHop_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Offset.Color = '#313695';
                                                            L2_Offset.LineStyle = '--';
                                                            L2_Offset.LineWidth = 2;
            
            
            
                                                            L3_Onset2 = line( [ TimePoint_SecondOnsetToGContactEnd(s), TimePoint_SecondOnsetToGContactEnd(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Onset2.Color = '#f46d43';
                                                            L3_Onset2.LineStyle = '-.';
                                                            L3_Onset2.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
                                                            legend('Rectified EMG','Flight Phase Offset', 'Flight Phase Offset Doublecheck', 'Pre-activation, Flight Only', 'Pre-activation, Entire Hop',...
                                                            'Pre-activation, Entire Hop, Time Threshold', 'Offset','Offset Doublecheck', 'Second Onset', 'GContact Begin','location','northeast')
    

                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
                                                            title( ['Rectified ', MuscleID{q}, ' EMG, 30 Hz Bandpass' ] )
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
            
                                                             hold off

                                                            linkaxes( [X1, X2, X3], 'x' )
    
                                                             pause
    
    
                                                            
%                                                             %Create a prompt so we can manually adjust the
%                                                             %muscle deactivation if needed
%                                                             PreactivationBeginFramePrompt =  'Enter the Frame for Beginning Preactivation';
%                                                             
%                                                             %Use inputdlg function to create a dialogue box for the prompt created above.
%                                                             %First arg is prompt, 2nd is title
%                                                             PreactivationBeginFrame_Cell = inputdlg( [ '\fontsize{15}' PreactivationBeginFramePrompt ], 'Enter the Frame for Beginning Preactivation', [1 150], {'0'} ,CreateStruct);


    
                                                            [ NewPreactivationTime_X, NewPreactivationTime_Y ] = ginput( 1 );
    
    
                                                            %Adjust pre-activation onset frame number. X
                                                            %coordinate is in seconds, so multiply by
                                                            %sampling rate to get frame number
                                                            FrameNumber_OnsetBeforeGContactBegin_FlightOnly( s ) = ( numel( FramesToUse_FlightPhaseOnly ) + 1 ) -  ceil( NewPreactivationTime_X  .* EMGSampHz );
                
    
    
                                                            %Adjust frame number of pre-activation onset,
                                                            %relative to entire trial (hops are not segmented
                                                            %out)
                                                            FrameNumber_OnsetBeforeGContactBegin_EntireTrial( s ) = GContactBegin_FrameNumbers( s ) - FrameNumber_OnsetBeforeGContactBegin_FlightOnly(s);
                                                            
    
                                                            %Find the time, in seconds, of pre-activation onset
                                                            TimePoint_OnsetBeforeGContactBegin_FlightOnly(s) = TimeofGContact_IndividualHop - NewPreactivationTime_X;
    
                
                                                            %Find the time of pre-activation onset - use this for
                                                            %plotting
                                                            TimePoint_MaxDifferencefromRefLine_FlightOnly_ForPlotting( s ) = NewPreactivationTime_X;
                
                
    
    
                                                            %Algorithm may tell us that muscle deactivates at
                                                            %end of flight phase. TimeVector_SthHop_FlightOnly_Normalizedto1 will only have 1
                                                            %element and we can't index into it using
                                                            %str2double( cell2mat( PreactivationBeginFrame_Cell . Will tell the code to
                                                            %only adjust
                                                            % PreactivationOnset_NormalizedTime_FlightOnly if
                                                            %TimeVector_SthHop_FlightOnly_Normalizedto1 has
                                                            %more than 1 element
                                                            if numel( TimeVector_SthHop_FlightOnly_Normalizedto1 ) >= 2
    
                                                                %Adjust pre-activation onset time, normalized to
                                                                %flight phase
                                                                PreactivationOnset_NormalizedTime_FlightOnly =  TimeVector_SthHop_FlightOnly_Normalizedto1( ceil( NewPreactivationTime_X  .* EMGSampHz ) );
    
                                                            end
    
    
    
    
                                                            %Find the number of frames for the duration of muscle
                                                            %activation
                                                            NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
                
                
                                                            %Create matrices of muscle EMG containing only the periods in
                                                            %which the muscle is active
    
    
                                                            %Change the number of frames vector.
                                                            NumberofFrames_OnsettoOffset( s ) = numel( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s ) );
    
    
                                                            %Create matrices of muscle EMG containing only the periods in
                                                            %which the muscle is active. First, set all
                                                            %frames for the current column of each matrix to
                                                            %NaN.
                                                            MuscleQ_Rectified_10HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Smoothed_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Normalized_10HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Normalized_10HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_10HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
    
                                                            MuscleQ_Rectified_30HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Smoothed_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Smoothed_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Normalized_30HzBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Normalized_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_30HzBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Rectified_NoBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
                                                            MuscleQ_Normalized_NoBandpass_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Normalized_NoBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Normalized_NoBandpass( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
            
                                                            MuscleQ_Rectified4Coherence_OnsettoOffset( :, s ) = NaN;
                                                            MuscleQ_Rectified4Coherence_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ) = MuscleQ_Rectified_forCoherence( FrameNumber_OnsetBeforeGContactBegin_EntireTrial(s) : FrameofMuscleOffset_EntireTrial_EMGSampHz( s )  );
    
    
    
    
                                                            figure( f2 );

                                                            %Set title for entire plot
                                                            sgtitle( [ 'Rectified EMG with Muscle Onset/Offset Lines - SD Threshold Method,  ', GroupList{ m }, '  ', ParticipantList{ n }, '  ', LimbID{ a }, '  ',  HoppingRate_ID{ b }, ' ', MuscleID{q}, '  ' , HoppingTrialNumber{p} ] )
        

                                                            X1 = subplot( 3, 1, 1 );
                                                            plot( AllFrames_SthHop_MoCap./MoCapSampHz, AnkleAngle_EntireSthHop, 'LineWidth', 2, 'Color' , 'k' )
    
                                                            hold on
        
                                                        
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
                                                                 [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;

    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ min( min( AnkleSagittalAngle ) ) - 5, max( max( AnkleSagittalAngle ) ) + 5 ] )
    
                                                            legend('Ankle Angle','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')                                                            
                                                            title( [ 'Ankle Angle, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( string_Angle )
    
                                                            hold off


                                                            %Subplot 2 - TA EMG
                                                            X2 = subplot( 3, 1, 2 );
    
                                                            if q ~= 5
    
                                                                plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, TATrialP_HopS, 'LineWidth', 2, 'Color' , 'b' )
    
                                                            end
    
                                                            hold on
            
                                                            
                                                            L_Preactivation_IndividualHopBaseline = line( [ TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s), TimeofGContact_IndividualHop - Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop(s) ],...
                                                                [ -30, max( max( TATrialP ) ) ] );
                                                            L_Preactivation_IndividualHopBaseline.Color = '#a50026';
                                                            L_Preactivation_IndividualHopBaseline.LineStyle = '-';
                                                            L_Preactivation_IndividualHopBaseline.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ -30, max( max( MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;

    
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
                                                            ylim( [ -30, max( max( TATrialP ) ) + 50 ] )
    
                                                            legend('EMG','Pre-activation, Individual Hop Baseline', 'GContact Begin','location','northwest')
                                                            title( [ 'Rectified TA EMG, 30 Hz Bandpass, Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
    
                                                            hold off



                                                            X3 = subplot(3, 1, 3 );
                                                            plot( ( 1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ) )./EMGSampHz, MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated(1 : LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s ),s), 'LineWidth', 2, 'Color' , 'k' )
                                                            hold on
        
                                                            L_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase( s ), TimeofMuscleOffset_FlightPhase( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_FlightOffset.Color = '#74add1';
                                                            L_FlightOffset.LineStyle = '--';
                                                            L_FlightOffset.LineWidth = 2;
            
            
                                                            L2_FlightOffset = line( [ TimeofMuscleOffset_FlightPhase_DoubleCheck( s ), TimeofMuscleOffset_FlightPhase_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_FlightOffset.Color = '#74add1';
                                                            L2_FlightOffset.LineStyle = '-.';
                                                            L2_FlightOffset.LineWidth = 2;
            
            
                                                            L_Preactivation = line( [ TimePoint_MaxDifferencefromRefLine_FlightOnly_ForPlotting(s), TimePoint_MaxDifferencefromRefLine_FlightOnly_ForPlotting(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Preactivation.Color = '#a50026';
                                                            L_Preactivation.LineStyle = '-';
                                                            L_Preactivation.LineWidth = 2;
            
                                                            
                                                            L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Preactivation.Color = '#d73027';
                                                            L2_Preactivation.LineStyle = '--';
                                                            L2_Preactivation.LineWidth = 2;
            
                                                            
                                                            L3_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ), TimePoint_MaxDifferencefromReferenceLine_EntireHop_Method2( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Preactivation.Color = '#d73027';
                                                            L3_Preactivation.LineStyle = '-.';
                                                            L3_Preactivation.LineWidth = 2;
            
            
                                                            L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L_Offset.Color = '#313695';
                                                             L_Offset.LineStyle = '-.';
                                                            L_Offset.LineWidth = 2;
            
            
                                                            L2_Offset = line( [ TimeofMuscleOffset_EntireHop_DoubleCheck( s ), TimeofMuscleOffset_EntireHop_DoubleCheck( s ) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L2_Offset.Color = '#313695';
                                                            L2_Offset.LineStyle = '--';
                                                            L2_Offset.LineWidth = 2;
            
           
            
                                                            L3_Onset2 = line( [ TimePoint_SecondOnsetToGContactEnd(s), TimePoint_SecondOnsetToGContactEnd(s) ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
                                                            L3_Onset2.Color = '#f46d43';
                                                            L3_Onset2.LineStyle = '-.';
                                                            L3_Onset2.LineWidth = 2;
                    
            
                                                            L_BeginGContact = line( [ TimeofGContact_IndividualHop, TimeofGContact_IndividualHop ],...
                                                                [ 0, max( max( MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated ) ) ] );
            
                                                            L_BeginGContact.Color = '#fdae61';
                                                            L_BeginGContact.LineStyle = '-';
                                                            L_BeginGContact.LineWidth = 2;
    
    
                                                            legend('Rectified EMG','Flight Phase Offset', 'Flight Phase Offset Doublecheck', 'Pre-activation, Flight Only', 'Pre-activation, Entire Hop',...
                                                                'Pre-activation, Entire Hop, Time Threshold', 'Offset','Offset Doublecheck', 'Second Onset', 'GContact Begin','location','northeast')

                                                            xlabel('Time (s)')
                                                            ylabel( RawHoppingUnits_string )
                                                            title( ['Rectified ', MuscleID{q}, ' EMG, 30 Hz Bandpass' ] )
                                                            xlim( [ 0, ( LengthofEntireHopCycle_NonTruncated_EMGSamplingHz( s )./EMGSampHz ) + 0.05 ] )
            
                                                             hold off

                                                             linkaxes( [ X1, X2, X3 ], 'x' )
                                                         
                                                            savefig( [ ParticipantList{ n }, '_', 'Plot Rectified EMG with Muscle OnsetOffset Lines - Santello McDonagh', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, 'Hop ', num2str( s ), '.fig' ] );
            
                                                             pause
        
    
    
        
                                                            % Plot Rectified Muscle Activation - Onset to Offset    
                                                            
                                                            figure( f3 );
                                                            plot( ( 1 : NumberofFrames_OnsettoOffset( s ) )./EMGSampHz, MuscleQ_Rectified_30HzBandpass_OnsettoOffset( 1 : NumberofFrames_OnsettoOffset( s )  , s ), 'LineWidth', 2, 'Color' , 'k' )
    
                                                            title( [ 'Hop ', num2str( s ), ' of ', num2str( numel( GContactBegin_FrameNumbers(:,p) ) ) ] )
                                                         
                                                            savefig( [ ParticipantList{ n }, '_', 'Plot Rectified EMG from Onset to Offset', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, 'Hop ', num2str( s ), '.fig' ] );

                                                            pause
    
    
                                                        end%End if statement for adjusting pre-activation onset
    
        
        %                                                  subplot( 3, 1, 2 )
        % 
        %                                                 plot( ReferenceLine_FlightOnly_XAxis', ReferenceLine_FlightOnly_YAxis', 'LineWidth', 2, 'Color' , 'r' )
        %                                                 hold on
        %                                                 plot( TimeVector_SthHop_FlightOnly_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly, 'LineWidth', 2, 'Color', '#0072BD' )
        %                                                 L_Preactivation = line( [ PreactivationOnset_NormalizedTime_FlightOnly, PreactivationOnset_NormalizedTime_FlightOnly ],...
        %                                                     [ MuscleQ_IntegratedEMG_CumSum_Normalized_FlightOnly(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s)),...
        %                                                     ReferenceLine_FlightOnly_YAxis(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s))  ] );
        %                                                 L_Preactivation.Color = '#7E2F8E';
        %                                                 L_Preactivation.LineStyle = '-';
        %                                                 L_Preactivation.LineWidth = 2;
        %         
        %                                                 % Adds text to plot to show what the activation onset time
        %                                                 % was.
        %                                                 text(PreactivationOnset_NormalizedTime_FlightOnly, ReferenceLine_FlightOnly_YAxis(FrameNumber_MaxDifferencefromReferenceLine_FlightOnly(s)) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_FlightOnly(s)) ], 'FontSize', 12)
        %                                                 hold off
        % 
        % 
        % 
        %                                                 subplot( 3, 1, 3 )
        %                                                 plot( ReferenceLine_EntireHop_XAxis', ReferenceLine_EntireHop_YAxis', 'LineWidth', 2, 'Color' , 'r' )
        %                                                 hold on
        %                                                 plot( TimeVector_SthHop_EntireHop_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop, 'LineWidth', 2, 'Color', '#0072BD' )
        %                                                 L_Preactivation = line( [ PreactivationOnset_NormalizedTime_EntireHop, PreactivationOnset_NormalizedTime_EntireHop ],...
        %                                                     [ MuscleQ_IntegratedEMG_CumSum_Normalized_EntireHop(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s)),...
        %                                                     ReferenceLine_EntireHop_YAxis(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s))  ] );
        %                                                 L_Preactivation.Color = '#7E2F8E';
        %                                                 L_Preactivation.LineStyle = '-';
        %                                                 L_Preactivation.LineWidth = 2;
        %         
        %                                                 % Adds text to plot to show what the activation onset time
        %                                                 % was.
        %                                                 text(PreactivationOnset_NormalizedTime_EntireHop, ReferenceLine_EntireHop_YAxis(FrameNumber_MaxDifferencefromReferenceLine_EntireHop(s)) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_EntireHop(s)) ], 'FontSize', 12)
        %                                                 hold off
        
            
            
        
                                                        
        %                                                     figure('Name','Illustration of Second Burst Onset Detection')
        %                                                     plot( ReferenceLine_OffsetToGContactEnd_XAxis', ReferenceLine_OffsetToGContactEnd_YAxis', 'LineWidth', 2, 'Color' , 'r' )
        %                                                     hold on
        %                                                     plot( TimeVector_SthHop_OffsetToGContactEnd_Normalizedto1, MuscleQ_IntegratedEMG_CumSum_Normalized_OffsetToGContactEnd, 'LineWidth', 2, 'Color', '#0072BD' )
        %                                                     L_Preactivation = line( [ PreactivationOnset_NormalizedTime_FlightOnly, PreactivationOnset_NormalizedTime_FlightOnly ],...
        %                                                         [ MuscleQ_IntegratedEMG_CumSum_Normalized_OffsetToGContactEnd( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) ),...
        %                                                         ReferenceLine_OffsetToGContactEnd_YAxis( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) )  ] );
        %                                                     L_Preactivation.Color = '#7E2F8E';
        %                                                     L_Preactivation.LineStyle = '-';
        %                                                     L_Preactivation.LineWidth = 2;
        %             
        %                                                     % Adds text to plot to show what the activation onset time
        %                                                     % was.
        %                                                     text(PreactivationOnset_NormalizedTime_OffsetToGContactEnd, ReferenceLine_OffsetToGContactEnd_YAxis( FrameNumber_MaxDifferencefromReferenceLine_OffsetToGContactEnd(s) ) + 0.1, [' Preactivation Onset =  ' num2str(TimePoint_OnsetBeforeGContactBegin_FlightOnly(s)) ], 'FontSize', 12)
        %                                                     hold off
        % 
        %                                                  pause
        % 
        %                                                  close
        % 
        %                                                 if s == 1
        % 
        %                                                     f13 = figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ], 'Name','Rectified EMG with Muscle Onset/Offset');
        %                                                     
        %                                                     subplot( size(MuscleQ_Rectified_IndividualHops, 2) , 1, s )
        %                                                     plot( ( 1 : LengthofHop_EMGData( s, p) )./EMGSampHz, MuscleQ_Rectified_IndividualHops(1 : LengthofHop_EMGData(s,p),s), 'LineWidth', 2, 'Color' , 'k' )
        %                                                     hold on
        % 
        %                                                     L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Preactivation.Color = '#a50026';
        %                                                     L_Preactivation.LineStyle = '-';
        %                                                     L_Preactivation.LineWidth = 2;
        % 
        %                                                     L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Offset.Color = '#54278f';
        %                                                      L_Offset.LineStyle = '-.';
        %                                                     L_Offset.LineWidth = 2;
        % 
        %                                                     L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L2_Preactivation.Color = '#54278f';
        %                                                     L2_Preactivation.LineStyle = '--';
        %                                                     L2_Preactivation.LineWidth = 2;
        % 
        %                                                     L_BeginGContact = line( [ TimeofGContact, TimeofGContact ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        % 
        %                                                     L_BeginGContact.Color = '#fdae61';
        %                                                     L_BeginGContact.LineStyle = '-';
        %                                                     L_BeginGContact.LineWidth = 2;
        %             
        %                                                      hold off
        % 
        %                                                 else
        % 
        %                                                     figure( f13 )
        % 
        %                                                     subplot( size(MuscleQ_Rectified_IndividualHops, 2) , 1, s )
        %                                                     plot( ( 1 : LengthofHop_EMGData( s, p) )./EMGSampHz, MuscleQ_Rectified_IndividualHops(1 : LengthofHop_EMGData(s,p),s), 'LineWidth', 2, 'Color' , 'k' )
        %                                                     hold on
        % 
        %                                                     L_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s), TimePoint_MaxDifferencefromReferenceLine_FlightOnly(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Preactivation.Color = '#a50026';
        %                                                     L_Preactivation.LineStyle = '-';
        %                                                     L_Preactivation.LineWidth = 2;
        % 
        %                                                     L_Offset = line( [ TimeofMuscleOffset_EntireHop( s ), TimeofMuscleOffset_EntireHop( s ) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L_Offset.Color = '#54278f';
        %                                                      L_Offset.LineStyle = '-.';
        %                                                     L_Offset.LineWidth = 2;
        % 
        %                                                     L2_Preactivation = line( [ TimePoint_MaxDifferencefromReferenceLine_EntireHop(s), TimePoint_MaxDifferencefromReferenceLine_EntireHop(s) ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        %                                                     L2_Preactivation.Color = '#54278f';
        %                                                     L2_Preactivation.LineStyle = '--';
        %                                                     L2_Preactivation.LineWidth = 2;
        % 
        %                                                     L_BeginGContact = line( [ TimeofGContact, TimeofGContact ],...
        %                                                         [ 0, max( max( MuscleQ_Rectified_IndividualHops ) ) ] );
        % 
        %                                                     L_BeginGContact.Color = '#fdae61';
        %                                                     L_BeginGContact.LineStyle = '-';
        %                                                     L_BeginGContact.LineWidth = 2;
        %             
        %                                                     hold off
        
                                                end  %End if statement for plotting rectified EMG with onset and offset times
                                                
    
    
    
    
        %% !!ADD Data to Pre-activation Onset Table for R
    
    
                                                %If we have NOT added Participant N data, add it to table for
                                                %exporting
                                                if strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Yes' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' )
                                                    
                                                    %Add group number to 1st column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 1) = m;
                                                    %Add participant number to 2nd column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 2) = n;
                                                    %Add Limb ID to 3rd column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 3) = a;
                                                    %Add Muscle ID to 4th column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 4) = q;
                                                    %Add Trial Number to 5th column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 5) = p;
                                                    %Add Hop Number to 6th column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 6) = s;
                                                    %Add Hopping Rate to 7th column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 7)  = HoppingRate_ID_forTable(b);%Add preactivation onset time using entire hop cycle to first column
            
            
                                                    %Add preactivation onset time using entire hop cycle to 8th
                                                    %column - Santello McDonagh method
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 8) = TimePoint_OnsetBeforeGContactBegin_EntireHop(s);
                                                    %Add preactivation onset time using flight phase only to 9th column - Santello McDonagh method
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 9) = TimePoint_OnsetBeforeGContactBegin_FlightOnly(s);
                                                    %Add muscle offset time, relative to onset, to 10th column
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 10) = TimeofMuscleOffset_EntireHop( s );
            
                                                    %Add threshold based muscle pre-activation onset time, to 14th
                                                    %column. Threshold is based on the resting EMG
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 11) = Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop( s );
                                                    %Add threshold based muscle pre-activation onset time, to 15th
                                                    %column. Threshold is based on the baseline for the individual
                                                    %hop
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 12) = Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop( s );
    
                                                    %Add time of ground contact, relative to entire hop
                                                    PreactivationOnsetTime_Table(RowtoFill_OnsetTable, 13) = TimeofGContact_IndividualHop;
        
        



                                                    %Save the Morphology for the current participant
                                                    Morphology = round( MorphologyLog.DifferenceinTendonThickness_mm( strcmp(  ParticipantList{ n } , MorphologyLog.Participant_ID ) ), 2 );
                                                    
                                                    %If processing the ATx group, find the VAS for the current participant, current hop rate, current limb
                                                    if strcmp( GroupList{m}, 'ATx' )
                                                
                                                        %Save the VAS for the current participant
                                                        VAS = round( VASLog.VAS_Score( strcmp(  ParticipantList{ n } , VASLog.Participant ) & strcmp(  LimbID{a} , VASLog.Limb ) & ( VASLog.HoppingRate == HoppingRate_ID_forTable( b )  ) ), 2 );
                                                    
                                                     %VAS for control group is always 0
                                                    else
                                                    
                                                        VAS = 0;
                                                    
                                                    end
                
                
                                                    %Set the between-limb morphology
                                                    PreactivationOnsetTime_Table( RowtoFill_OnsetTable, 14 ) = Morphology;
                                                     
                                                     %Set theVAS rating
                                                    PreactivationOnsetTime_Table( RowtoFill_OnsetTable, 15 )= VAS;
                                    
        
                
                                                    % Add one to RowtoFill so that next loop iteration will fill
                                                    % in the next row
                                                    RowtoFill_OnsetTable = RowtoFill_OnsetTable + 1;
                
                                                    clc
                                                
                                                end%%END IF STATEMENT FOR ADDING NEW DATA TO TABLE FOR EXPORT

                                            end%End If statement for reprocessing pre-activation

                                    end%%END S FOR LOOP
    
                                        %pause
    
    %% PLOT Santello-McDonagh preactivation onset time
    
                                         %Only show the figure below if we told the code to show all figures
                                        %for Participant N
                                         if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' ) && strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Yes' ) 
    
                                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Plot Preactivation Onset Time ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' _ ' HoppingRate_ID{b}, ' ', HoppingTrialNumber{p}])
                                            plot( TimePoint_OnsetBeforeGContactBegin_FlightOnly,'LineWidth',1.5,'Color','#0072BD','Marker',"hexagram","MarkerSize",10)
                                            title([ 'Preactivation Onset Time', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', HoppingTrialNumber{p}]  ,'FontSize',16)
                                            xlabel('Hop Number','FontSize',14)
                                            ylabel('Onset Time (Before Ground Contact) [s]')
    
                                            L = line( [ 1 numel( TimePoint_OnsetBeforeGContactBegin_FlightOnly ) ], [ mean( TimePoint_OnsetBeforeGContactBegin_FlightOnly, 'omitnan' ), mean( TimePoint_OnsetBeforeGContactBegin_FlightOnly, 'omitnan' ) ] );
                                            L.LineStyle = '--';
                                            L.LineWidth = 2;
    
                                            savefig( [ ParticipantList{ n }, '_', 'Plot Preactivation Onset Time', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );
    
                                            pause
                                            
                                         %End the If statement - whether to show the plot for Participant N   
                                         end
    
                                        
                                        %Find max length of downsampled hops
                                        MaxLength_IndividualHops_Downsampled = max(DownsampledLength_ofHopS);
    
                                        %Store length of each downsampled hop within MuscleQ_Normalized_IndividualHops_Downsampled
                                        MuscleQ_Normalized_10HzBandpass_IndividualHops_Downsampled(MaxLength_IndividualHops_Downsampled+1,:) = DownsampledLength_ofHopS;
    
                                        %Create a time vector for the maximum length of the individual hops.
                                        %Use this for plotting
                                        TimeVector_IndividualHops = (1:size(MuscleQ_Normalized_10HzBandpass_IndividualHops,1))./1500;
    
    
    
    
    
    %% PLOT SD Threshold preactivation onset time
    
                                         %Only show the figure below if we told the code to show all figures
                                        %for Participant N
                                         if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' ) && strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Yes' ) 
    
                                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Plot  Preactivation Onset Time ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' _ ' HoppingRate_ID{b}, ' ', HoppingTrialNumber{p}])
                                            plot( Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop,'LineWidth',1.5,'Color','#e66101','Marker',"hexagram","MarkerSize",10)
                                            hold on
                                            plot( Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop,'LineWidth',1.5,'Color','#5e3c99','Marker',"hexagram","MarkerSize",10)
                                            plot( TimePoint_OnsetBeforeGContactBegin_FlightOnly,'LineWidth',1.5,'Color','#0072BD','Marker',"hexagram","MarkerSize",10)
                                            title([ 'SD Threshold Preactivation Onset Time', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', HoppingTrialNumber{p}]  ,'FontSize',16)
                                            xlabel('Hop Number','FontSize',14)
                                            ylabel('Onset Time (Before Ground Contact) [s]')
    
                                            L = line( [ 1 numel( TimePoint_OnsetBeforeGContactBegin_FlightOnly ) ], [ mean( TimePoint_OnsetBeforeGContactBegin_FlightOnly, 'omitnan' ), mean( TimePoint_OnsetBeforeGContactBegin_FlightOnly, 'omitnan' ) ] );
                                            L.LineStyle = '-';
                                            L.LineWidth = 2;
    
                                            L2 = line( [ 1 numel( TimePoint_OnsetBeforeGContactBegin_FlightOnly ) ], [ mean( Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop, 'omitnan' ), mean( Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop, 'omitnan' ) ] );
                                            L2.LineStyle = '-.';
                                            L2.LineWidth = 2;
                                            L2.Color = '#e66101';
    
                                            L3 = line( [ 1 numel( TimePoint_OnsetBeforeGContactBegin_FlightOnly ) ], [ mean( Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop, 'omitnan' ), mean( Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop, 'omitnan' ) ] );
                                            L3.LineStyle = '-.';
                                            L3.LineWidth = 2;
                                            L3.Color = '#5e3c99';
    
                                            legend( 'Resting EMG Baseline', 'Baseline Per Hop', 'Santello-McDonagh', 'Santello-McDonagh Mean', 'Resting Baseline Mean', 'Individual Baseline Mean', 'FontSize', 14, 'Location', 'best' )
    
                                            savefig( [ ParticipantList{ n }, '_', 'Plot SD Threshold Preactivation Onset Time', '_', LimbID{ a }, '_', MuscleID{q}, ' _ ' HoppingRate_ID{ b }, '.fig' ] );
    
                                            pause
                                            
                                         %End the If statement - whether to show the plot for Participant N   
                                         end
    
                                        
    
                                        close all


%% Store EMG Data in Data Structure                                    

                                    %Save the raw EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Raw',MuscleQTrialP);

                                    %Save the DC offset removed EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'DC_Offset_Removed',MuscleQ_DCOffsetRemoved);

                                    %Store the 60 Hz notch filtered EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NotchFiltered_at60Hz',MuscleQ_NotchFilteredAt60Hz);

                                    %Store the 50 AND 60 Hz notch filtered EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NotchFiltered_at50Hz',MuscleQ_NotchFilteredAt50Hz);

                                    %Store the bandpass filtered EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'BandpassFiltered_10HzCutoff',MuscleQ_BandpassFiltered_10Hz);

                                    %Store the bandpass filtered EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'BandpassFiltered_30HzCutoff',MuscleQ_BandpassFiltered_30Hz);
                                    
                                    
                                    %Store the highpass filtered EMG (for coherence)  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'HighpassFiltered_forCoherence', MuscleQ_Highpassed4Coherence );
                                    
                                    

                                    %Store the rectified EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Rectified_10HzBandpass',MuscleQ_Rectified_10HzBandpass);
                                    
                                    

                                    %Store the rectified EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Rectified_30HzBandpass',MuscleQ_Rectified_30HzBandpass);
                                    

                                    %Store the rectified EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Rectified_NoBandpass',MuscleQ_Rectified_NoBandpass);

                                    
                                     %Store the rectified EMG (for coherence)  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Rectified_forCoherence',MuscleQ_Rectified_forCoherence);

                                    
                                    
                                    %Store the smoothed EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Smoothed_10HzBandpass',MuscleQ_Smoothed_10HzBandpass);

                                    %Store the normalized EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Normalized_10HzBandpass',MuscleQ_Normalized_10HzBandpass);

                                    %Store the rectified EMG, split into individual hops, in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_10HzBandpass',MuscleQ_Rectified_10HzBandpass_IndividualHops);

                                    %Store the rectified EMG, split into individual hops, in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_10HzBandpass',MuscleQ_Smoothed_10HzBandpass_IndividualHops);


                                    %Store the normalized EMG, split into individual hops  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_10HzBandpass',MuscleQ_Normalized_10HzBandpass_IndividualHops);

                                    %Store the contact phase of the rectified EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_10HzBandpass_ContactPhase',MuscleQ_Rectified_10HzBandpass_IndividualHops_ContactPhase);

                                    
                                    
                                    %Store the smoothed EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Smoothed_30HzBandpass',MuscleQ_Smoothed_30HzBandpass);

                                    %Store the normalized EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Normalized_30HzBandpass',MuscleQ_Normalized_30HzBandpass);

                                    %Store the normalized EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'HoppingEMG',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'Normalized_NoBandpass',MuscleQ_Normalized_NoBandpass);

                                    %Store the rectified EMG, split into individual hops, in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_30HzBandpass',MuscleQ_Rectified_30HzBandpass_IndividualHops);

                                    %Store the rectified EMG, split into individual hops, in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_30HzBandpass',MuscleQ_Smoothed_30HzBandpass_IndividualHops);


                                    %Store the normalized EMG, split into individual hops  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_30HzBandpass',MuscleQ_Normalized_30HzBandpass_IndividualHops);

                                    %Store the contact phase of the rectified EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_30HzBandpass_ContactPhase',MuscleQ_Rectified_30HzBandpass_IndividualHops_ContactPhase);



                                    %Store the rectified EMG, split into individual hops, in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_NoBandpass',MuscleQ_Rectified_NoBandpass_IndividualHops);

                                    %Store the rectified EMG, split into individual hops, in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_NoBandpass',MuscleQ_Normalized_NoBandpass_IndividualHops);

                                    
                                    %Store the contact phase of the high pass filtered EMG, for coherence,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_EntireHop_forCoherence', MuscleQ_Rectified4Coherence_IndividualHops);
                                    
                                    
                                     %Store the contact phase of the high pass filtered EMG, for coherence,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'HighpassedEMG_EntireHop_forCoherence', MuscleQ_Highpassed4Coherence_IndividualHops);
                                    

                                    
                                    %Store the contact phase of the high pass filtered EMG, for coherence,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_ContactPhase_forCoherence', MuscleQ_Rectified4Coherence_IndividualHops_ContactPhase);
                                    
                                    
                                     %Store the contact phase of the high pass filtered EMG, for coherence,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'HighpassedEMG_ContactPhase_forCoherence', MuscleQ_Highpassed4Coherence_IndividualHops_ContactPhase);
                                    
                                    
                                    
                                    %Store the contact phase of the smoothed EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_10HzBandpass_ContactPhase', MuscleQ_Smoothed_10HzBandpass_IndividualHops_ContactPhase);

                                    
                                    %Store the contact phase of the normalized EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_10HzBandpass_ContactPhase',MuscleQ_Normalized_10HzBandpass_IndividualHops_ContactPhase);
                                    
                                    
                                    
                                    %Store the contact phase of the smoothed EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_30HzBandpass_ContactPhase', MuscleQ_Smoothed_30HzBandpass_IndividualHops_ContactPhase);

                                    
                                    %Store the contact phase of the normalized EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_30HzBandpass_ContactPhase',MuscleQ_Normalized_30HzBandpass_IndividualHops_ContactPhase);


                                    
                                    
                                    %Store the contact phase of the normalized EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_NoBandpass_ContactPhase',MuscleQ_Rectified_NoBandpass_IndividualHops_ContactPhase);

                                    
                                    %Store the contact phase of the normalized EMG in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_NoBandpass_ContactPhase',MuscleQ_Normalized_NoBandpass_IndividualHops_ContactPhase);

                                    
                                    
                                    %Store the downsampled, rectified EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_10HzBandpass_Downsampled',MuscleQ_Rectified_10HzBandpass_IndividualHops_Downsampled);

                                    %Store the downsampled, normalized EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_10HzBandpass_Downsampled',MuscleQ_Normalized_10HzBandpass_IndividualHops_Downsampled);


                                    
                                    
                                    
                                    %Store the downsampled, rectified EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_30HzBandpass_Downsampled',MuscleQ_Rectified_30HzBandpass_IndividualHops_Downsampled);

                                    %Store the downsampled, normalized EMG  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_30HzBandpass_Downsampled',MuscleQ_Normalized_30HzBandpass_IndividualHops_Downsampled);





                                    %Store the rectified EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_10HzBandpass_Onset2GContactEnd',...
                                        MuscleQ_Rectified_10HzBandpass_OnsettoGContactEnd);

                                    %Store the smoothed EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_10HzBandpass_Onset2GContactEnd',...
                                        MuscleQ_Smoothed_10HzBandpass_OnsettoGContactEnd);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_10HzBandpass_Onset2GContactEnd',...
                                        MuscleQ_Normalized_10HzBandpass_OnsettoGContactEnd);

                                    %Store the rectified EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_30HzBandpass_Onset2GContactEnd',...
                                        MuscleQ_Rectified_30HzBandpass_OnsettoGContactEnd);

                                    %Store the smoothed EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_30HzBandpass_Onset2GContactEnd',...
                                        MuscleQ_Smoothed_30HzBandpass_OnsettoGContactEnd);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_30HzBandpass_Onset2GContactEnd',...
                                        MuscleQ_Normalized_30HzBandpass_OnsettoGContactEnd);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_NoBandpass_Onset2GContactEnd',...
                                        MuscleQ_Rectified_NoBandpass_OnsettoGContactEnd);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_NoBandpass_Onset2GContactEnd',...
                                        MuscleQ_Normalized_NoBandpass_OnsettoGContactEnd);
                                    



                                    %Store the rectified EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_10HzBandpass_Onset2Offset',...
                                        MuscleQ_Rectified_10HzBandpass_OnsettoOffset);

                                    %Store the smoothed EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_10HzBandpass_Onset2Offset',...
                                        MuscleQ_Smoothed_10HzBandpass_OnsettoOffset);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_10HzBandpass_Onset2Offset',...
                                        MuscleQ_Normalized_10HzBandpass_OnsettoOffset);

                                    %Store the rectified EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_30HzBandpass_Onset2Offset',...
                                        MuscleQ_Rectified_30HzBandpass_OnsettoOffset);

                                    %Store the smoothed EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_30HzBandpass_Onset2Offset',...
                                        MuscleQ_Smoothed_30HzBandpass_OnsettoOffset);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_30HzBandpass_Onset2Offset',...
                                        MuscleQ_Normalized_30HzBandpass_OnsettoOffset);

                                    %Store the rectified EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_4Coherence_Onset2Offset',...
                                        MuscleQ_Rectified4Coherence_OnsettoOffset);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_NoBandpass_Onset2Offset',...
                                        MuscleQ_Rectified_NoBandpass_OnsettoOffset);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_NoBandpass_Onset2Offset',...
                                        MuscleQ_Normalized_NoBandpass_OnsettoOffset);



                                    


                                    %Store the rectified EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_10HzBandpass_NonTruncated',...
                                        MuscleQ_RectifiedEMG_10HzBandpass_IndividualHops_NonTruncated );

                                    %Store the smoothed EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_10HzBandpass_NonTruncated',...
                                        MuscleQ_SmoothedEMG_10HzBandpass_IndividualHops_NonTruncated);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_10HzBandpass_NonTruncated',...
                                        MuscleQ_NormalizedEMG_10HzBandpass_IndividualHops_NonTruncated);

                                    %Store the rectified EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'RectifiedEMG_30HzBandpass_NonTruncated',...
                                        MuscleQ_RectifiedEMG_30HzBandpass_IndividualHops_NonTruncated );

                                    %Store the smoothed EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'SmoothedEMG_30HzBandpass_NonTruncated',...
                                        MuscleQ_SmoothedEMG_30HzBandpass_IndividualHops_NonTruncated);

                                    %Store the normalized EMG, from muscle onset to end of ground contact,  in the data structure
                                    David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'NormalizedEMG_30HzBandpass_NonTruncated',...
                                        MuscleQ_NormalizedEMG_30HzBandpass_IndividualHops_NonTruncated);




%% Store Indexing Data in Data Structure

                                        if strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Yes' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'Y' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'y' ) || strcmp( cell2mat( ReprocessPreactivation_Cell ), 'yes' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'Y' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'y' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'yes' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'Yes' )
                                           
                                            %Store the preactivation onset frame, using the entire hop cycle,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'PreactivationOnsetFrame_Relative2GContactBegin_EntireHopCycle',...
                                                FrameNumber_OnsetBeforeGContactBegin_EntireHop);
        
                                            %Store the preactivation onset data, using the entire hop cycle,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'PreactivationOnsetTime_Relative2GContactBegin_EntireHopCycle',...
                                                TimePoint_OnsetBeforeGContactBegin_EntireHop);
        
                                            %Store the preactivation onset frame, using only the flight phase  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'PreactivationOnsetFrame_Relative2GContactBegin_OnlyFlightPhase',...
                                                FrameNumber_OnsetBeforeGContactBegin_FlightOnly);
        
                                            %Store the preactivation onset data, using only the flight phase  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'PreactivationOnsetTime_Relative2GContactBegin_OnlyFlightPhase',...
                                                TimePoint_OnsetBeforeGContactBegin_FlightOnly);
        
                                            %Store the preactivation onset frame, using only the flight phase  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'PreactivationOnsetFrame_Relative2EntireTrial_OnlyFlightPhase',...
                                                FrameNumber_OnsetBeforeGContactBegin_EntireTrial);
        
                                            %Store the preactivation onset data, using only the flight phase  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'PreactivationOnsetTime_Relative2EntireTrial_OnlyFlightPhase',...
                                                TimePoint_OnsetBeforeGContactBegin_EntireTrial);
        
        
        
                                            
                                            
                                            %Store the muscle offset frame, relative to muscle onset,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetFrame_Relative2Onset',...
                                                FrameofMuscleOffset_AfterOnset_EMGSampHz_DoubleCheck);
        
                                            %Store the muscle offset time, relative to muscle onset,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetTime_sec_Relative2Onset',...
                                                TimeofMuscleOffset_AfterOnset_DoubleCheck);
        
        
        
        
        
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetFrame_Relative2EntireHop',...
                                                FrameofMuscleOffset_EntireHop_EMGSampHz);
                                            
                                            %Store the muscle offset time, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetTime_sec_Relative2EntireHop',...
                                                TimeofMuscleOffset_EntireHop);
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetFrame_Relative2EntireTrial_NonTruncated',...
                                                FrameofMuscleOffset_EntireTrial_EMGSampHz);
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffset_sec_Relative2EntireTrial_NonTruncated',...
                                                TimeofMuscleOffset_EntireTrial);
        
        
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetFrame_Relative2EntireHop_Method2',...
                                                FrameofMuscleOffset_EntireHop_EMGSampHz);
                                            
                                            %Store the muscle offset time, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetTime_sec_Relative2EntireHop_Method2',...
                                                TimeofMuscleOffset_EntireHop_DoubleCheck);
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffsetFrame_Relative2EntireTrial_NonTruncated_Method2',...
                                                FrameofMuscleOffset_EntireTrial_EMGSampHz_DoubleCheck);
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOffset_sec_Relative2EntireTrial_NonTruncated_Method2',...
                                                TimeofMuscleOffset_EntireTrial_DoubleCheck);
        
        
        
        
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofHop_Onset2Offset_Frames',...
                                                NumberofFrames_OnsettoOffset );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofFlightPhase_Onset2Offset_Frames',...
                                                FrameNumber_OnsetBeforeGContactBegin_FlightOnly );
        
        
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'FrameofGContactBegin_Onset2Offset',...
                                                FrameofGContactBegin_Onset2Offset );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofGroundContactPhase_Onset2Offset_Frames',...
                                                LengthofGroundContactPhase_Onset2Offset_Frames );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofBrakingPhase_Onset2Offset_Frames',...
                                                LengthofBrakingPhase_Onset2Offset_Frames );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'FrameofBrakingPhaseBegin_Onset2Offset',...
                                                FrameofBrakingPhaseBegin_Onset2Offset );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'FrameofBrakingPhaseEnd_Onset2Offset',...
                                                FrameofBrakingPhaseEnd_Onset2Offset );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'LengthofPropulsionPhase_Onset2Offset_Frames',...
                                                LengthofPropulsionPhase_Onset2Offset_Frames );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'FrameofPropulsionPhaseBegin_Onset2Offset',...
                                                FrameofPropulsionPhaseBegin_Onset2Offset );
        
                                            %Store the muscle offset frame, relative to the entire hop,  in the data structure
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'FrameofPropulsionPhaseEnd_Onset2Offset',...
                                                FrameofPropulsionPhaseEnd_Onset2Offset );
        
        
        
        
        
        
        %% Store Indexing Data in Data Structure - SD Threshold Based Method
        
        
                                            %Store the muscle onset frame, relative to the entire hop, using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOnsetFrame_SDThreshold_RestingEMG',...
                                                OnsetFrame_SDThreshold_RestingEMG );
                                            
                                            %Store the muscle onset frame, relative to ground contact for the entire hop, using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOnsetFrameB4GContact_SDThreshold_RestingEMG_IndividualHop',...
                                                Frame_OnsetB4Contact_SDThreshold_RestingEMG_IndividualHop );
                                            
                                            %Store the muscle onset frame, relative to ground contact (frames relative to the entire trial), using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOnsetFrameB4GContact_SDThreshold_RestingEMG_EntireTrial',...
                                                Frame_OnsetB4GContact_SDThreshold_RestingEMG_EntireTrial );
                                            
                                            %Store the muscle onset time, relative to ground contact for the entire hop, using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOnsetTimeB4GContact_SDThreshold_RestingEMG_IndividualHop',...
                                                Time_OnsetB4Contact_SDThreshold_RestEMG_IndividualHop );
                                            
                                            %Store the muscle onset time, relative to ground contact (frames relative to the entire trial), using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOnsetTimeB4GContact_SDThreshold_RestingEMG_EntireTrial',...
                                                Time_OnsetB4Contact_SDThreshold_RestEMG_EntireTrial );
        
        
        
        
        
        
        
        
        
                                            %Store the muscle onset frame, relative to the entire hop, using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'MuscleOnsetFrame_SDThreshold_EachHopBaseline',...
                                                OnsetFrame_SDThreshold_EachHopBaseline );
                                            
                                            %Store the muscle onset frame, relative to ground contact for the entire hop, using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'OnsetFrameB4GContact_SDThreshold_EachHopBaseline_IndividualHop',...
                                                Frame_OnsetB4Contact_SDThreshold_EachHopBaseline_IndividualHop );
                                            
                                            %Store the muscle onset frame, relative to ground contact (frames relative to the entire trial), using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'OnsetFrameB4GContact_SDThreshold_EachHopBaseline_EntireTrial',...
                                                Frame_OnsetB4GContact_SDThreshold_EachHopBaseline_EntireTrial );
                                            
                                            %Store the muscle onset time, relative to ground contact for the entire hop, using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'OnsetTimeB4GContact_SDThreshold_EachHopBaseline_IndividualHop',...
                                                Time_OnsetB4Contact_SDThreshold_BaselinePerHop_IndividualHop );
                                            
                                            %Store the muscle onset time, relative to ground contact (frames relative to the entire trial), using the
                                            %SD threshold method. Baseline is Resting EMG.
                                            David_DissertationEMGDataStructure =...
                                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},HoppingRate_ID{b},HoppingTrialNumber{p},'OnsetTimeB4GContact_SDThreshold_EachHopBaseline_EntireTrial',...
                                                Time_OnsetB4Contact_SDThreshold_BaselinePerHop_EntireTrial );

                                        end







                                end
                                

                                    %Store LastDataPointofHop_EMGData in the data structure
                                    David_DissertationEMGDataStructure = setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...                                 
                                        HoppingRate_ID{b},'LastDataPointofHop_EMGSampHz',LastDataPointofHop_EMGData );
                                    
                                    
                                    %Save preactivation onset matrix (not a MATLAB table) in the data structure
                                    David_DissertationEMGDataStructure = setfield(David_DissertationEMGDataStructure, QualvsPostQualData{ l }, 'AllGroups', 'PreactivationOnsetTime_Matrix', PreactivationOnsetTime_Table);

                                    %Store MinLengthofFlightPhase_EMGSamplingHz in the data structure
                                    David_DissertationEMGDataStructure =...
                                            setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},MuscleID{q},'MinLengthofFlightPhase_EMGSampHz',HoppingRate_ID{b},MinLengthofFlightPhase_EMGSamplingHz );
        
%                             
%                                 %Create pop-up dialog box displaying the value of minimum power absorption AND generation
%                                 MSGBox2 = msgbox( { [ '\fontsize{20} Finished processing ', MuscleID{q}, ' of ', ParticipantList{n}, '  ', HoppingRate_ID{ b } ]   }  , CreateStruct);
%         
%                                 %Don't execute the next line of code until user responds to dialog box above
%                                 uiwait( MSGBox2 )
                                    
                                    
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







%% SECTION 4 - Calculate Participant and Group Means for Preactivation + Export Tables

    %Will use these to know which row to fill in the joint power and joint behavior index means
    RowtoFill_Preactivation_GroupMeans = 1;
    RowtoFill_Preactivation_ParticipantMeans = 1;
    
    %Initialize matrices to hold joint power and joint behavior index means
    Preactivation_GroupMeansPerHoppingRate = NaN( 1, 20 ); 
    Preactivation_ParticipantMeansPerHoppingRate = NaN( 1, 21 ); 
  


    

%Begin M For Loop - Loop Through Groups    
for m = 1:numel(GroupList)

    %Use get field to create a new data structure containing the list of participants. List of participants is
    %stored under the second field of the structure (the list of groups)


    %Need to know which rows in the 1st column of PreactivationOnsetTime_Table correspond to the Mth
    %group
    Preactivation_IndicesForOneGroup = find( PreactivationOnsetTime_Table(:, 1) == m );

    %Create a new joint power matrix containing only Group M
    Preactivation_OneGroup = PreactivationOnsetTime_Table( Preactivation_IndicesForOneGroup, :);







    %If Group being processed is ATx, set Participant List to contain list of ATx participants.
    %If Group being processed is Controls, set Participant List to contain list of Control
    %participants.
    if strcmp( GroupList{m}, 'ATx' )

        ParticipantList = ATxParticipantList;

        HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};

        HoppingRate_ID_forTable = [0, 2, 2.33];
        
        LimbID = [1, 2];

    else

        ParticipantList = ControlParticipantList;

        HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};

        HoppingRate_ID_forTable = [0, 2, 2.33];
        
        LimbID = 1;

    end





%% Begin A For Loop - Loop Through Limbs

    for a = 1:numel(LimbID)


        %Need to know which rows in the 3rd column of Preactivation_OneGroup correspond to Limb A
        Preactivation_IndicesForOneLimb = find( Preactivation_OneGroup(:, 3) == a );


        %Create a new joint power matrix containing only Limb A
        Preactivation_OneLimb = Preactivation_OneGroup( Preactivation_IndicesForOneLimb, :);



%% Begin B For Loop - Loop Through Hopping Rates      

            for b = 1 : numel( HoppingRate_ID)



                %Need to know which rows in the 14th column of Preactivation_OneLimb correspond
                %to Hopping Rate B
                Preactivation_IndicesforOneRate = find( Preactivation_OneLimb( :, 3) == HoppingRate_ID_forTable(b) );

                %Create a new joint power matrix containing only Hopping Rate B
                Preactivation_OneRate = Preactivation_OneLimb( Preactivation_IndicesforOneRate, : );



                %Need to create a vector containing the values  for  each Muscle (1 for ankle, 2 for knee, 3
                %for hip )
                VectorofUniqueMuscles = unique( Preactivation_OneRate( :, 4 ) );


%% Begin C For Loop - Loop Through Each Muscle

                for c = 1 : length( VectorofUniqueMuscles ) 

                    

                    %Need to know which rows in the 7th column of Preactivation_OneRate
                    %correspond to Muscle C
                    Preactivation_IndicesforOneMuscle = find( Preactivation_OneRate( :, 4 ) == VectorofUniqueMuscles( c ) );

                    %Create a new Muscle power matrix containing only Muscle C
                    Preactivation_OneMuscle = Preactivation_OneRate( Preactivation_IndicesforOneMuscle, : );




                    %We want to take average of participant data, so fist create a vector containing
                    %Participant IDs. Use unique() to get rid of repeating IDs.
                    VectorofUniqueParticipants = unique( Preactivation_OneMuscle( :, 2 ) );


                    %Take average of Group_ID Column column of Preactivation_OneMuscle and store in the next row of Column 1 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 1 ) = mean(  Preactivation_OneMuscle(:, 1), 1, 'omitnan'  );

                    %Take average of Limb_ID Column column of Preactivation_OneMuscle and store in the next row of Column 2 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 2 ) = mean(  Preactivation_OneMuscle(:, 3), 1, 'omitnan'  );

                    %Take average of Muscle_ID Column column of Preactivation_OneMuscle and store in the next row of Column 3 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 3 ) = mean(  Preactivation_OneMuscle(:, 4), 1, 'omitnan'  );

                    %Take average of HoppingRate_ID Column column of Preactivation_OneMuscle and store in the next row of Column 4 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 4 ) = mean(  Preactivation_OneMuscle( :, 7), 1, 'omitnan'  );



                    %Take average of Preactivation_Onset_Time_Insec_EntireHopCycleData and store in the next row of Column 5 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 5 ) = mean(  Preactivation_OneMuscle( :, 8 ), 1, 'omitnan'  );

                    %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 6 ) = mean(  Preactivation_OneMuscle( :, 9 ), 1, 'omitnan'  );

                    %Take average of MuscleOffset time, in seconds, and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 7 ) = mean(  Preactivation_OneMuscle( :, 10 ), 1, 'omitnan'  );



                    %Take average of Preactivation_Onset_Time_Insec_EntireHopCycleData and store in the next row of Column 5 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 8 ) = mean(  Preactivation_OneMuscle( :, 11 ), 1, 'omitnan'  );

                    %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 9 ) = mean(  Preactivation_OneMuscle( :, 12 ), 1, 'omitnan'  );

                    %Take average of MuscleOffset time, in seconds, and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 10 ) = mean(  Preactivation_OneMuscle( :, 13 ), 1, 'omitnan'  );

                    %Take average of MuscleOffset time, in seconds, and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 11 ) = mean(  Preactivation_OneMuscle( :, 14 ), 1, 'omitnan'  );

                    %Take average of MuscleOffset time, in seconds, and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 12 ) = mean(  Preactivation_OneMuscle( :, 15 ), 1, 'omitnan'  );


                    %Find standard deviation of each preactivation variable
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 13 ) = std(  Preactivation_OneMuscle( :, 8 ), 'omitnan'  );
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 14 ) = std(  Preactivation_OneMuscle( :, 9 ), 'omitnan'  );
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 15 ) = std(  Preactivation_OneMuscle( :, 10 ), 'omitnan'  );


                    %Find standard deviation of each preactivation variable
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 16 ) = std(  Preactivation_OneMuscle( :, 11 ), 'omitnan'  );
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 17 ) = std(  Preactivation_OneMuscle( :, 12 ), 'omitnan'  );
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 18 ) = std(  Preactivation_OneMuscle( :, 13 ), 'omitnan'  );

                    %Take average of MuscleOffset time, in seconds, and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 19 ) = std(  Preactivation_OneMuscle( :, 14 ), 1, 'omitnan'  );

                    %Take average of MuscleOffset time, in seconds, and store in the next row of Column 6 of Preactivation_GroupMeansPerHoppingRate
                    Preactivation_GroupMeansPerHoppingRate( RowtoFill_Preactivation_GroupMeans, 20 ) = std(  Preactivation_OneMuscle( :, 15 ), 1, 'omitnan'  );

                    %Add 1 to RowtoFill_Preactivation  so the next loop will fill the next row of Preactivation_GroupMeansPerHoppingRate
                    RowtoFill_Preactivation_GroupMeans =  RowtoFill_Preactivation_GroupMeans + 1;
                    





 %% Begin E For Loop - Loop Through Participants
                    for e = 1 : numel( VectorofUniqueParticipants )
                    
                    
                        Preactivation_IndicesforOneParticipant = find( Preactivation_OneMuscle( :, 2 ) == VectorofUniqueParticipants( e ) );
                    
                        %Create a new Muscle power matrix containing only Participant E
                        Preactivation_OneParticipant = Preactivation_OneMuscle( Preactivation_IndicesforOneParticipant, : );

                        

                        %Take average of Group_ID Column column of Preactivation_OneParticipant and store in the next row of Column 1 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 1 ) = mean(  Preactivation_OneParticipant( :, 1 ), 1, 'omitnan'  );

                        %Take average of Participant_ID Column column of Preactivation_OneParticipant and store in the next row of Column 2 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 2 ) = mean(  Preactivation_OneParticipant(:,2), 1, 'omitnan'  );
    
                        %Take average of Limb_ID Column column of Preactivation_OneParticipant and store in the next row of Column 3 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 3 ) = mean(  Preactivation_OneParticipant(:,3), 1, 'omitnan'  );
    
                        %Take average of Muscle_ID Column column of Preactivation_OneParticipant and store in the next row of Column 4 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 4 ) = mean(  Preactivation_OneParticipant(:,4), 1, 'omitnan'  );
    
                        %Take average of HoppingRate_ID Column column of Preactivation_OneParticipant and store in the next row of Column 5 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 5 ) = mean(  Preactivation_OneParticipant(:,7), 1, 'omitnan'  );
    

                        %Take average of Preactivation_Onset_Time_Insec_EntireHopCycleData and store in the next row of Column 6 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 6 ) = mean(  Preactivation_OneParticipant(:,8), 1, 'omitnan'  );
    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 7 ) = mean(  Preactivation_OneParticipant(:,9), 1, 'omitnan'  );
    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 8 ) = mean(  Preactivation_OneParticipant(:,10), 1, 'omitnan'  );
    

                        %Take average of Preactivation_Onset_Time_Insec_EntireHopCycleData and store in the next row of Column 6 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 9 ) = mean(  Preactivation_OneParticipant(:,11), 1, 'omitnan'  );
    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 10 ) = mean(  Preactivation_OneParticipant(:,12), 1, 'omitnan'  );
    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 11 ) = mean(  Preactivation_OneParticipant(:,13), 1, 'omitnan'  );


    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 12 ) = mean(  Preactivation_OneParticipant(:,14 ), 1, 'omitnan'  );
    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 13 ) = mean(  Preactivation_OneParticipant(:,15 ), 1, 'omitnan'  );
    
    
                        %Find standard deviation of each preactivation variable
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 14 ) = std(  Preactivation_OneParticipant( :, 8 ), 'omitnan'  );
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 15 ) = std(  Preactivation_OneParticipant( :, 9 ), 'omitnan'  );
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 16 ) = std(  Preactivation_OneParticipant( :, 10 ), 'omitnan'  );
    
    
                        %Find standard deviation of each preactivation variable
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 17 ) = std(  Preactivation_OneParticipant( :, 11 ), 'omitnan'  );
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 18 ) = std(  Preactivation_OneParticipant( :, 12 ), 'omitnan'  );
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 19 ) = std(  Preactivation_OneParticipant( :, 13 ), 'omitnan'  );


    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 20 ) = std(  Preactivation_OneParticipant(:,14 ), 1, 'omitnan'  );
    
                        %Take average of Preactivation_Onset_Time_Insec_FlightPhaseDataOnly and store in the next row of Column 7 of Preactivation_ParticipantMeansPerHoppingRate
                        Preactivation_ParticipantMeansPerHoppingRate( RowtoFill_Preactivation_ParticipantMeans, 21 ) = std(  Preactivation_OneParticipant(:,15 ), 1, 'omitnan'  );
    
                        %Add 1 to RowtoFill_Preactivation  so the next loop will fill the next row of Preactivation_ParticipantMeansPerHoppingRate
                        RowtoFill_Preactivation_ParticipantMeans =  RowtoFill_Preactivation_ParticipantMeans + 1;




                       
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
    
    
%Want to clear the errors for the new section
lasterror = [];

    
%Create a list of variable names - these will be the column headers for the preactivation onset
%table
VariableNames = {'Group_ID', 'Participant_ID', 'Limb_ID' , 'Muscle_ID','Trial_ID','Hop_ID','HoppingRate_ID',...
    'Preactivation_Onset_Time_Insec_EntireHopCycleData', 'Preactivation_Onset_Time_Insec_FlightPhaseDataOnly', 'MuscleOffsetTime_RelativeToOnset',...
    'PreactivationOnsetTime_SDThreshold_RestingEMGBaseline', 'PreactivationOnsetTime_SDThreshold_BaselinePerHop',...
    'BetweenLimbTendonThickness_mm', 'VAS_Rating' };

%Create table of preactivation onset data
PreactivationOnsetTime_Table_forR = array2table(PreactivationOnsetTime_Table, 'VariableNames', VariableNames);
    
%Export preactivation onset table as .xlsx file
writetable(PreactivationOnsetTime_Table_forR,'POSTQUALS_PreactivationOnsetTime_Table_forR.xlsx');

%Save preactivation onset table in the data structure
David_DissertationEMGDataStructure = setfield(David_DissertationEMGDataStructure, QualvsPostQualData{ l }, 'AllGroups', 'PreactivationOnsetTime_Table', PreactivationOnsetTime_Table_forR);

%Save preactivation onset matrix (not a MATLAB table) in the data structure
%RUN THIS TO SAVE PROCESSED DATA
David_DissertationEMGDataStructure = setfield(David_DissertationEMGDataStructure, QualvsPostQualData{ l }, 'AllGroups', 'PreactivationOnsetTime_Matrix', PreactivationOnsetTime_Table);





%Set variable names for creaitng tables from the Preactivation_GroupMeansPerHoppingRate and
%Preactivation_ParticipantMeansPerHoppingRate data
VariableNames_Preactivation_GroupMeans = {'Group_ID','Limb_ID','Muscle_ID','HoppingRate_ID',...
    'Mean_Preactivation_Onset_Time_Insec_EntireHopCycleData', 'Mean_Preactivation_Onset_Time_Insec_FlightPhaseDataOnly', 'Mean_MuscleOffsetTime_RelativeToOnset'...
    'Mean_PreactivationOnsetTime_SDThreshold_RestingEMGBaseline', 'Mean_PreactivationOnsetTime_SDThreshold_BaselinePerHop',...
    'Mean_BetweenLimbTendonThickness_mm', 'Mean_VAS_Rating',... 
     'SD_Preactivation_Onset_Time_Insec_EntireHopCycleData', 'SD_Preactivation_Onset_Time_Insec_FlightPhaseDataOnly', 'SD_MuscleOffsetTime_RelativeToOnset',...
    'SD_PreactivationOnsetTime_SDThreshold_RestingEMGBaseline', 'SD_PreactivationOnsetTime_SDThreshold_BaselinePerHop',...
    'SD_BetweenLimbTendonThickness_mm', 'SD_VAS_Rating'  };

%Create a table from the Preactivation_GroupMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( Preactivation_GroupMeansPerHoppingRate, 'VariableNames', VariableNames_Preactivation_GroupMeans ), 'PostQuals_Preactivation_GroupMeansPerHoppingRate_OneControlLimb.xlsx' );







%Set variable names for creaitng tables from the Preactivation_GroupMeansPerHoppingRate and
%Preactivation_ParticipantMeansPerHoppingRate data
VariableNames_Preactivation_ParticipantMeans = {'Group_ID','Participant_ID','Limb_ID','Muscle_ID','HoppingRate_ID',...
    'Mean_Preactivation_Onset_Time_Insec_EntireHopCycleData','Mean_Preactivation_Onset_Time_Insec_FlightPhaseDataOnly','Mean_MuscleOffsetTime_RelativeToOnset'...
    'Mean_PreactivationOnsetTime_SDThreshold_RestingEMGBaseline', 'Mean_PreactivationOnsetTime_SDThreshold_BaselinePerHop',...
    'Mean_BetweenLimbTendonThickness_mm', 'Mean_VAS_Rating',... 
     'SD_Preactivation_Onset_Time_Insec_EntireHopCycleData','SD_Preactivation_Onset_Time_Insec_FlightPhaseDataOnly', 'SD_MuscleOffsetTime_RelativeToOnset',...
    'SD_PreactivationOnsetTime_SDThreshold_RestingEMGBaseline', 'SD_PreactivationOnsetTime_SDThreshold_BaselinePerHop',...
    'SD_BetweenLimbTendonThickness_mm', 'SD_VAS_Rating' };

%Create a table from the Preactivation_ParticipantMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( Preactivation_ParticipantMeansPerHoppingRate, 'VariableNames', VariableNames_Preactivation_ParticipantMeans ), 'PostQuals_Preactivation_ParticipantMeansPerHoppingRate_OneControlLimb.xlsx' );

    




clearvars -except David_DissertationEMGDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList DataCategories_HoppingKinematicsKinetics ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz ATxParticipantMass ControlParticipantMass CreateStruct

clc




%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 5',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end