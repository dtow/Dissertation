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



%% SECTION 2 - Create Field Variables

%First field within data structure = data for quals versus for remainder of dissertation
QualvsPostQualData = {'Post_Quals'};
%Second field = group list
% GroupList = {'ATx','Control'};
GroupList = { 'ATx', 'Control' };


% % Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36' };
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC08', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45' };


% ControlParticipantList = {'HP03','HP08'};

%4th field = data type
DataCategories_HoppingKinematicsKinetics = {'HoppingKinematicsKinetics'};
DataCategories_IndividualHops = {'IndividualHops'};

%5th field = limb ID
ControlLimbID = {'LeftLimb','RightLimb'};
ATxLimbID = {'InvolvedLimb','NonInvolvedLimb'};

%Specify sampling rates for GRF, EMG, kinematics/kinetics
GRFSampHz = 1500;
EMGSampHz = 1500;
MoCapSampHz = 250;

% %Create vector of participant masses
ATxParticipantMass = [ 71.43, 64.66, 107.47, 84.35, 83.07, 71.43, 84.39, 81.96, 90.30, 79.08, 79.67, 87.51, 58.12, 61.82, 90.18, 80.99, 65.79 ]; 
%ATx07, ATx08, ATx10, ATx12, ATx17, ATx18, ATx19, ATx21, ATx24, ATx25, ATx27, ATx34, ATx38, ATx41, ATx44,
%ATx50, ATx36
ControlParticipantMass = [ 57.24, 83.50, 61.37, 80.99, 105.01, 61.66, 77.14, 82.00, 75.66, 79.75, 68.08, 75.28, 65.44, 82.52 ]; 
%HC01, HC05, HC06, HC08, HC11, HC12, HC17, HC18, HC19, HC20, HC21, HC25, HC42, HC45


%We only have one trial of data for each hopping rate, for now
 HoppingTrialNumber = {'Trial1'};


 %Set vectors containing between-limb difference in tendon thickness for each participant
    %ATx Group - %ATx07, ATx08, ATx10, ATx12, ATx17, ATx18, ATx19, ATx21, ATx24, ATx25, ATx27, ATx34,
    %ATx38, ATx41, ATx44, ATx50, ATx36
ATxMorphology = [ 0.75, 2.41, 1.4, 0.5, 1.57, 3.69, 2.58, 1.21, 1.94, 1.84, 2.84, 1.9, 0.43,  1.4, 3.18, 0.94, 1.09  ];
    %Control Group - HC01, HC05, HC06, HC08, HC11, HC12, HC17, HC18, HC19, HC20, HC21, HC25, HC42, HC45
ControlMorphology = [ 0.55, 0.55, 0.35, 0.55, 0.63, 0.55, 0.55, 0.62, 0.55, 0.55, 0.55, 0.55, 0.5, 0.4 ];



%Set vectors containing visual analog scale rating after each hopping bout, for each participant
    %ATx Group
        %Involved Limb
            %Preferred Hz
ATxVAS_Involved_PreferredHz = [ 0, 2, 0, 0, 4, 1, 2.5, 0, 0, 0, 3, 3, 0, 0, 1.5, 0, 0 ];
            %2.0 Hz
ATxVAS_Involved_TwoHz = [ 0, 1, 0, 6.5, 4, 1, 3, 0, 0, 0, 1, 1, 0, 0, 1.5, 0, 0 ];
            %2.3 Hz
ATxVAS_Involved_TwoPoint3Hz = [ 0, 0, 0, 6, 3, 1, 3, 0, 0, 0, 0, 2, 0, 0, 1.5, 0, 0 ];
        %Non-Involved Limb
            %Preferred Hz
ATxVAS_NonInvolved_PreferredHz = [ 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0 ];
            %2.0 Hz
ATxVAS_NonInvolved_TwoHz = [ 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0 ];
            %2.3 hz
ATxVAS_NonInvolved_TwoPoint3Hz = [ 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0 ];
    %Control Group
ControlVAS = 0;


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end








 
 
%% !!SECTION 3 - Split Angular Position and Torque Data Up Into Individual Hops


for l = 1 : numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});

    
    
    
 %% Begin M For Loop - Loop Through Groups    
    
    for m = 2%1 : numel(GroupList)
        
        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
        ParticipantListDataStructure = getfield(GroupListDataStructure,GroupList{m});
        
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
        
        
        for n = 14%1 : numel(ParticipantList)
            
            
            %Create a prompt so we can manually enter the group of interest
            ShowPlotsPrompt = [ 'Show Plots for  ', ParticipantList{n}, '?' ];

            %Use inputdlg function to create a dialogue box for the prompt created above.
            %First arg is prompt, 2nd is title
            ShowPlots_Cell = inputdlg( [ '\fontsize{15}' ShowPlotsPrompt ], 'Show Plots?', [1 150], {'No'} ,CreateStruct);
            
            
            
            %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
            ListofDataTypes_DataStructure = getfield(ParticipantListDataStructure,ParticipantList{n});
            
            

            %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %tables, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{n}, 'ATx07'  )
             
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx08'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx10'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx12'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                

                
           elseif strcmp( ParticipantList{n}, 'ATx17'  )
             
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };     
                
                

            elseif strcmp( ParticipantList{n}, 'ATx18'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
           elseif strcmp( ParticipantList{n}, 'ATx19'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = { 'TwoHz', 'TwoPoint3Hz'};     
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx21'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = { 'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};   
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx24'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                HoppingRate_ID = { 'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};   
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx25'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = { 'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};   
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx27'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx34'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx36'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx38'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx41'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx44'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx50'  )
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                
                
            elseif strcmp( ParticipantList{n}, 'HC11'  )
                
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                LimbID_forV3DOutput = { 'LeftLimb',  'RightLimb' };
                
                HoppingRate_ID = { 'TwoHz', 'TwoPoint3Hz'}; 
                
                
                
            else
                
                LimbID = {'LeftLimb','RightLimb'};
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
            end
            
            
            
            
            %Participant HP08 has MoCap sampling Hz of 150 instead of 250, HP02 has MoCap sampling
            %Hz of 300. All others have MoCap sampling Hz of 250
            if strcmp( ParticipantList{ n }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ n }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
            
            
            ParticipantNMass = ParticipantMass(n);
            ParticipantNWeight = ParticipantNMass.*9.81;

            
            
 %% Begin A For Loop - Loop Through Limbs            
            
            
            for a = 1 : numel(LimbID)
                
                
                
                %Use get field to create a new data structure containing the list of limbs. Stored under the 4th field of the structure (the list of data categories)
                Listof_LimbIDsforIndexing_DataStructure = getfield(ListofDataTypes_DataStructure,'UseforIndexingIntoData');

                %Index into same data structure, but want to pull out the original data table
                Listof_LimbIDsforOriginalDataTable_DataStructure = getfield(ListofDataTypes_DataStructure,'HoppingKinematicsKinetics');
                    
                IndexingDataWithinMTU_ID_DataStructure = getfield(Listof_LimbIDsforIndexing_DataStructure,LimbID{a});
                
                DataWithinMTU_IDforOriginalDataTable_DataStructure = getfield(Listof_LimbIDsforOriginalDataTable_DataStructure,LimbID{a});



                        
                        
    %% Begin B Loop - Run Through Each Hopping Rate
                        for b = 1 : numel(HoppingRate_ID)                        
                        
                            
                            LengthofFlightPhase_GRFSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            LengthofContactPhase_GRFSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            NumEl_SthHop_MoCapSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            GContactBegin_MoCapFrameNumbers = NaN(4,numel(HoppingTrialNumber));
                            GContactEnd_forContactPhase_MoCapFrameNumbers = NaN(4,numel(HoppingTrialNumber));

                            FirstDataPoint_SthHop_MoCapSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            LastDataPoint_SthHop_MoCapSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            LastDataPoint_SthHop_GRFSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            NumEl_SthHopContactPhase_MoCapSamplingHz = NaN(4,numel(HoppingTrialNumber));
                            NumEl_SthHopContactPhase_GRFSamplingHz = NaN(4,numel(HoppingTrialNumber));

                            MinLengthofFlightPhase_MoCapSamplingHz = NaN(4,1);

                            
                            
                            HoppingRateB_OriginalDataTable = getfield(DataWithinMTU_IDforOriginalDataTable_DataStructure, HoppingRate_ID{b} );

                            IndexingDataWithinHoppingRateB_DataStructure =  getfield( IndexingDataWithinMTU_ID_DataStructure, HoppingRate_ID{b} );
                            

                            
                            
                            if strcmp( ParticipantList{n}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz' )
                                
                                HoppingTrialNumber = {'Trial1'};
                                

                            elseif strcmp( ParticipantList{n}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )
                                
                                HoppingTrialNumber = {'Trial1','Trial2'};
                                
                                
                            else

                                HoppingTrialNumber = {'Trial1'};
                                
                            end
                            
                            
                            
    %% Begin Q Loop - Run Through Each Hopping Trial
                            for q = 1:numel(HoppingTrialNumber)

    %% Initialize Variables Within Q Loop

                                AnkleAngleSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                AnkleTorqueSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                AnkleAngleFrontal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                AnkleTorqueFrontal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                AnkleAngleTransverse_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                AnkleTorqueTransverse_IndividualHops = NaN(4,numel(HoppingTrialNumber));

                                KneeAngleSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneeTorqueSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneeAngleFrontal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneeTorqueFrontal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneeAngleTransverse_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneeTorqueTransverse_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneePowerSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));

                                HipAngleSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                HipTorqueSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                HipAngleFrontal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                HipTorqueFrontal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                HipAngleTransverse_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                HipTorqueTransverse_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                ShankAngleSagittal_IndividualHops= NaN(4,numel(HoppingTrialNumber));
                                ThighAngleSagittal_IndividualHops= NaN(4,numel(HoppingTrialNumber));
                                PelvisAngleSagittal_IndividualHops= NaN(4,numel(HoppingTrialNumber));

                                NumEl_SthHop = NaN(4,1);
                                NumEl_SthHop_MoCap = NaN(4,1);

                                AnkleAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                AnkleTorqueSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                AnkleAngleFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                AnkleTorqueFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                AnkleAngleTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                AnkleTorqueTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));

                                KneeAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeTorqueSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngleFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeTorqueFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngleTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeTorqueTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));

                                HipAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipTorqueSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngleFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipTorqueFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngleTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipTorqueTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));

                                ShankAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                ThighAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                PelvisAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));

                                




                                HoppingTrialP_OriginalDataTable = getfield(HoppingRateB_OriginalDataTable, HoppingTrialNumber{q} );


                                
                                
                                 %Extract the frame number corresponding to the beginning of ground
                                  %contact - this was stored in the data structure. The frames we
                                  %are extracting are in the motion capture sampling Hz                                
                                GContactBegin_MoCapFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.BeginGroundContact_MoCapFrames;
                                
                                                                
                                %Extract the frame number corresponding to the end of ground
                                %contact - this was stored in the data structure. The frames we
                                %are extracting are in the motion capture sampling Hz
                                GContactEnd_forContactPhase_MoCapFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.EndGroundContact_forContactPhase_MoCapFrames;
                                
                                                                
                                %Find the first data point of each hop, for the entire hop
                                %cycle. We classify beginning of hop cycle as first frame of
                                %flight phase. Use tranpose because the vector is currently a row
                                %vector, but our indexing requires a column vector   
                                FirstDataPoint_SthHop_MoCapSamplingHz = IndexingDataWithinHoppingRateB_DataStructure.FirstDataPointofSthHop_Truncated_MoCapSamplingHz';
                                
                                %Find the shortest duration of the flight phase. The flight phase
                                %lengths were stored in the data structure.
                                MinLengthofFlightPhase_MoCapSamplingHz( 1 : length( GContactBegin_MoCapFrameNumbers ), q) = min( IndexingDataWithinHoppingRateB_DataStructure.LengthofFlightPhase_NonTruncated_MoCapSamplingHz );
                                
                                
                                
                                
                                
                                %Run loop once for each element within the Qth row of RLimb_GContactBegin_Frames
                                for s = 1:numel(GContactBegin_MoCapFrameNumbers(:,q))



                                    %Create a vector containing all Frames for the Sth hop, from the
                                    %beginning of one flight phase and the beginning of the next. Subtract
                                    %one from the GContactEnd frame number since the frame number is the
                                    %first frame of flight phase. Want to end at the last frame of contact
                                    %phase
                                    AllFrames_SthHop_MoCap = FirstDataPoint_SthHop_MoCapSamplingHz(s,q):(GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);

                                    LastDataPoint_SthHop_MoCapSamplingHz(s,q) = (GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);

                                    %Find the number of elements of the Sth hop.
                                    NumEl_SthHop_MoCap(s) = numel(AllFrames_SthHop_MoCap);

    %% Begin If Statement - V3D will export data with RAnkle vs LAnkle - will use If loop along with string comparison

    %If LimbID == Left, change the variable names to LAnkle.... etc. Otherwise (else if portion), change
    %the variable names to RAnkle... etc

                                    if strcmp( LimbID_forV3DOutput{a}, 'LeftLimb')
                                        %Split Ankle Angular Position, Torque, Power into Individual Hops
                                        AnkleAngleSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Angle(AllFrames_SthHop_MoCap);
    
                                        AnkleTorqueSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Torque(AllFrames_SthHop_MoCap);
    
                                        AnkleAngleFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Angle_1(AllFrames_SthHop_MoCap);
    
                                        AnkleTorqueFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Torque_1(AllFrames_SthHop_MoCap);
    
                                        AnkleAngleTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Angle_2(AllFrames_SthHop_MoCap);
    
                                        AnkleTorqueTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Torque_2(AllFrames_SthHop_MoCap);
    
    
                                        %Split Knee Angular Position, Torque, Power into Individual Hops
                                        KneeAngleSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Angle(AllFrames_SthHop_MoCap);
    
                                        KneeTorqueSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Torque(AllFrames_SthHop_MoCap);
    
                                        KneeAngleFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Angle_1(AllFrames_SthHop_MoCap);
    
                                        KneeTorqueFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Torque_1(AllFrames_SthHop_MoCap);
    
                                        KneeAngleTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Angle_2(AllFrames_SthHop_MoCap);
    
                                        KneeTorqueTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Torque_2(AllFrames_SthHop_MoCap);



                                        %Split Hip Angular Position, Torque, Power into Individual Hops
                                        HipAngleSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Angle(AllFrames_SthHop_MoCap);
    
                                        HipTorqueSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Torque(AllFrames_SthHop_MoCap);
    
                                        HipAngleFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Angle_1(AllFrames_SthHop_MoCap);
    
                                        HipTorqueFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Torque_1(AllFrames_SthHop_MoCap);
    
                                        HipAngleTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Angle_2(AllFrames_SthHop_MoCap);
    
                                        HipTorqueTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Torque_2(AllFrames_SthHop_MoCap);
    
    
    
    
                                        %%Create variables containing the kinematics and kinetics for ground
                                        %%contact phase ONLY
                                        AllFrames_SthHopContactPhase_MoCap = GContactBegin_MoCapFrameNumbers(s,q):(GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);
    
                                        %Find the number of elements of the Sth hop contact phase.
                                        NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) = numel(AllFrames_SthHopContactPhase_MoCap);





        %% Split L Ankle Angular Position, Torque into the contact phase of individual Hops
                                        AnkleAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Angle(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Torque(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Angle_1(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Torque_1(AllFrames_SthHopContactPhase_MoCap);
                                        
                                        AnkleAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Angle_2(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_Torque_2(AllFrames_SthHopContactPhase_MoCap);

        %% Split L Knee Angular Position, Torque into the contact phase of Individual Hops
                                        KneeAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Angle(AllFrames_SthHopContactPhase_MoCap);
    
                                        KneeTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Torque(AllFrames_SthHopContactPhase_MoCap);                               
    
                                        KneeAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Angle_1(AllFrames_SthHopContactPhase_MoCap);
    
                                        KneeTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Torque_1(AllFrames_SthHopContactPhase_MoCap);                               
    
                                        KneeAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Angle_2(AllFrames_SthHopContactPhase_MoCap);
    
                                        KneeTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_Torque_2(AllFrames_SthHopContactPhase_MoCap);                               


        %% L Split Hip Angular Position, Torque into the contact phase of Individual Hops
                                        HipAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Angle(AllFrames_SthHopContactPhase_MoCap);
    
                                        HipTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Torque(AllFrames_SthHopContactPhase_MoCap);        
    
                                        HipAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Angle_1(AllFrames_SthHopContactPhase_MoCap);
    
                                        HipTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Torque_1(AllFrames_SthHopContactPhase_MoCap);        
    
                                        HipAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Angle_2(AllFrames_SthHopContactPhase_MoCap);
    
                                        HipTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_Torque_2(AllFrames_SthHopContactPhase_MoCap);        


%% Split L Segment Angles into  Individual Hops

                                        %Split Shank Angular Position into Individual Hops
                                        ShankAngleSagittal_IndividualHops( 1 : NumEl_SthHop_MoCap( s ), s ) =...
                                            HoppingTrialP_OriginalDataTable.LShank_Angle( AllFrames_SthHop_MoCap );
    
    
                                        %Split Pelvis Angular Position into Individual Hops
                                        PelvisAngleSagittal_IndividualHops( 1 : NumEl_SthHop_MoCap( s ), s ) =...
                                            HoppingTrialP_OriginalDataTable.Pelvis_Angle( AllFrames_SthHop_MoCap );
    
                                        %Split Thigh Angular Position into Individual Hops
                                        ThighAngleSagittal_IndividualHops( 1 : NumEl_SthHop_MoCap( s ), s ) =...
                                            HoppingTrialP_OriginalDataTable.LThigh_Angle( AllFrames_SthHop_MoCap );  


%% Split L Segment Angles into the contact phase of Individual Hops

                                        %Split Shank Angular Position into Individual Hops
                                        ShankAngleSagittal_IndividualHopsContactPhase( 1 : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) =...
                                            HoppingTrialP_OriginalDataTable.LShank_Angle( AllFrames_SthHopContactPhase_MoCap );
    
    
                                        %Split Pelvis Angular Position into Individual Hops
                                        PelvisAngleSagittal_IndividualHopsContactPhase( 1 : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) =...
                                            HoppingTrialP_OriginalDataTable.Pelvis_Angle( AllFrames_SthHopContactPhase_MoCap );
    
                                        %Split Thigh Angular Position into Individual Hops
                                        ThighAngleSagittal_IndividualHopsContactPhase( 1 : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) =...
                                            HoppingTrialP_OriginalDataTable.LThigh_Angle( AllFrames_SthHopContactPhase_MoCap );          



    %% Else If portion of Loop  - for Right Limb

                                    elseif strcmp( LimbID_forV3DOutput{a}, 'RightLimb')

%% Split R Ankle Angular Position, Torque, Power into Individual Hops


                                        AnkleAngleSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle(AllFrames_SthHop_MoCap);
    
                                        AnkleTorqueSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Torque(AllFrames_SthHop_MoCap);
    
                                        AnkleAngleFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle_1(AllFrames_SthHop_MoCap);
    
                                        AnkleTorqueFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Torque_1(AllFrames_SthHop_MoCap);
    
                                        AnkleAngleTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle_2(AllFrames_SthHop_MoCap);
    
                                        AnkleTorqueTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Torque_2(AllFrames_SthHop_MoCap);




%% Split R Knee Angular Position, Torque into Individual Hops

                                        %Split Knee Angular Position, Torque, Power into Individual Hops
                                        KneeAngleSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle(AllFrames_SthHop_MoCap);
    
                                        KneeTorqueSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Torque(AllFrames_SthHop_MoCap);
    
                                        KneeAngleFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle_1(AllFrames_SthHop_MoCap);
    
                                        KneeTorqueFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Torque_1(AllFrames_SthHop_MoCap);
    
                                        KneeAngleTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle_2(AllFrames_SthHop_MoCap);
    
                                        KneeTorqueTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Torque_2(AllFrames_SthHop_MoCap);





%% Split R Hip Angular Position, Torque into Individual Hops
                                        HipAngleSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle(AllFrames_SthHop_MoCap);
    
                                        HipTorqueSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Torque(AllFrames_SthHop_MoCap);
    
                                        HipAngleFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle_1(AllFrames_SthHop_MoCap);
    
                                        HipTorqueFrontal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Torque_1(AllFrames_SthHop_MoCap);
    
                                        HipAngleTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle_2(AllFrames_SthHop_MoCap);
    
                                        HipTorqueTransverse_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Torque_2(AllFrames_SthHop_MoCap);



%% Split R Segment Angles into  Individual Hops

                                        %Split Shank Angular Position into Individual Hops
                                        ShankAngleSagittal_IndividualHops( 1 : NumEl_SthHop_MoCap( s ), s ) =...
                                            HoppingTrialP_OriginalDataTable.RShank_Angle( AllFrames_SthHop_MoCap );
    
    
                                        %Split Pelvis Angular Position into Individual Hops
                                        PelvisAngleSagittal_IndividualHops( 1 : NumEl_SthHop_MoCap( s ), s ) =...
                                            HoppingTrialP_OriginalDataTable.Pelvis_Angle( AllFrames_SthHop_MoCap );
    
                                        %Split Thigh Angular Position into Individual Hops
                                        ThighAngleSagittal_IndividualHops( 1 : NumEl_SthHop_MoCap( s ), s ) =...
                                            HoppingTrialP_OriginalDataTable.RThigh_Angle( AllFrames_SthHop_MoCap );
    
    
                                        %%Create variables containing the kinematics and kinetics for ground
                                        %%contact phase ONLY
                                        AllFrames_SthHopContactPhase_MoCap = GContactBegin_MoCapFrameNumbers(s,q):(GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);
    
                                        %Find the number of elements of the Sth hop contact phase.
                                        NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) = numel(AllFrames_SthHopContactPhase_MoCap);
                                    




        %% Split Ankle Angular Position, Torque into the contact phase of individual Hops
                                        AnkleAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Torque(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle_1(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Torque_1(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle_2(AllFrames_SthHopContactPhase_MoCap);
    
                                        AnkleTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Torque_2(AllFrames_SthHopContactPhase_MoCap);



        %% Split Knee Angular Position, Torque into the contact phase of Individual Hops
                                        KneeAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle(AllFrames_SthHopContactPhase_MoCap);
    
                                        KneeTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Torque(AllFrames_SthHopContactPhase_MoCap);         
                                        
                                        KneeAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle_1(AllFrames_SthHopContactPhase_MoCap);
    
                                        KneeTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Torque_1(AllFrames_SthHopContactPhase_MoCap);         
    
                                        KneeAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle_2(AllFrames_SthHopContactPhase_MoCap);
    
                                        KneeTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Torque_2(AllFrames_SthHopContactPhase_MoCap);         


        %% Split Hip Angular Position, Torque into the contact phase of Individual Hops
                                        HipAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle(AllFrames_SthHopContactPhase_MoCap);
    
                                        HipTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Torque(AllFrames_SthHopContactPhase_MoCap);   
    
                                        HipAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle_1(AllFrames_SthHopContactPhase_MoCap);
    
                                        HipTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Torque_1(AllFrames_SthHopContactPhase_MoCap);   
    
                                        HipAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle_2(AllFrames_SthHopContactPhase_MoCap);
    
                                        HipTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Torque_2(AllFrames_SthHopContactPhase_MoCap);   


%% Split R Segment Angles into the contact phase of Individual Hops

                                        %Split Shank Angular Position into Individual Hops
                                        ShankAngleSagittal_IndividualHopsContactPhase( 1 : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) =...
                                            HoppingTrialP_OriginalDataTable.RShank_Angle( AllFrames_SthHopContactPhase_MoCap );
    
    
                                        %Split Pelvis Angular Position into Individual Hops
                                        PelvisAngleSagittal_IndividualHopsContactPhase( 1 : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) =...
                                            HoppingTrialP_OriginalDataTable.Pelvis_Angle( AllFrames_SthHopContactPhase_MoCap );
    
                                        %Split Thigh Angular Position into Individual Hops
                                        ThighAngleSagittal_IndividualHopsContactPhase( 1 : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) =...
                                            HoppingTrialP_OriginalDataTable.RThigh_Angle( AllFrames_SthHopContactPhase_MoCap );                                        

                                    end




        %% Plot Ankle Contact Phase Hops

                                    TimeVector_AnkleTorque = (1:size(AnkleAngleSagittal_IndividualHopsContactPhase,1))./MoCapSampHz;
                                    s_Ankle = sprintf('Angle (%c) [- = PF/+ = DF]',char(176));

                                    %Use ShowPlots_Cell to determine whether to show the plots or not
                                    if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )

                                        %Only show the plots if we are processing the last hop
                                        if s == numel(GContactBegin_MoCapFrameNumbers(:,q) )

                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Ankle  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )
    
                                            subplot(3, 1, 1)
                                            plot(TimeVector_AnkleTorque, AnkleTorqueSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            ylim( [ -4, 2 ] )
                                            yticks( -4:0.5:2 )
                                            set( gca, 'FontSize', 12 )
                                            title('Ankle Torque - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque [- = PF/+ = DF]','FontSize',14)
                                            legend('Location','bestoutside')
    
                                            subplot(3, 1, 2)
                                            plot(TimeVector_AnkleTorque, AnkleAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_Ankle,'FontSize',14)
                                            legend('Location','bestoutside')
    
                                            subplot(3, 1, 3)
                                            plot(TimeVector_AnkleTorque, ShankAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Shank Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_Ankle, 'FontSize', 14)
                                            legend('Location','bestoutside')
    
    
                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'AnkleAngleTorque', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );
    
    
            %%  Plot Knee Contact Phase Hops
    
                                            s_KneeHip = sprintf('Angle (%c) [- = Ext/+ = Flex]',char(176));
    
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Knee  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )
    
                                            subplot(4, 1, 1)
                                            plot(TimeVector_AnkleTorque,KneeTorqueSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            ylim( [ -4, 2 ] )
                                            yticks( -4:0.5:2 )
                                            set( gca, 'FontSize', 12 )
                                            title('Knee Torque - Contact Phase Only','FontSize',16)
                                            ylabel('Torque [- = Ext/+ = Flex]','FontSize',14)
                                            xlabel('Time (s)','FontSize',14)
    
                                            legend('Location','bestoutside')
                                            subplot(4, 1, 2)
                                            plot(TimeVector_AnkleTorque,KneeAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHip,'FontSize',14)
                                            legend('Location','bestoutside')
    
                                            subplot(4, 1, 3)
                                            plot(TimeVector_AnkleTorque, ShankAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Shank Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_Ankle, 'FontSize', 14)
                                            legend('Location','bestoutside')
    
                                            subplot(4, 1, 4)
                                            plot(TimeVector_AnkleTorque, ThighAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Thigh Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHip, 'FontSize', 14)
                                            legend('Location','bestoutside')
    
    
                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'KneeAngleTorque', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );
    
                                            
    
    
    
    
            %% Plot Hip Contact Phase Hops
    
                                            s_Pelvis = sprintf('Angle (%c) [- = Posteriort/+ = Anterior]',char(176));
    
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Hip  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )
    

    
                                            subplot(4,1,1)
                                            plot(TimeVector_AnkleTorque,HipTorqueSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Torque - Contact Phase Only','FontSize',16)
                                            ylim( [ -4, 2 ] )
                                            yticks( -4:0.5:2 )
                                            set( gca, 'FontSize', 12 )
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque [- = Ext/+ = Flex]','FontSize',14)
                                            legend('Location','bestoutside')

                                            subplot(4,1,2)
                                            plot(TimeVector_AnkleTorque,HipAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHip,'FontSize',14)
                                            legend('Location','bestoutside')
    
                                            subplot(4, 1, 3)
                                            plot(TimeVector_AnkleTorque, ThighAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Thigh Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHip, 'FontSize', 14)
                                            legend('Location','bestoutside')
    
                                            subplot(4, 1, 4)
                                            plot(TimeVector_AnkleTorque, PelvisAngleSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            L = line([0  max(TimeVector_AnkleTorque)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Pelvis Angle - Contact Phase Only','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_Pelvis, 'FontSize', 14)
                                            legend('Location','bestoutside')
    
    
                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'HipAngleTorque', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all

                                        
                                        end%End If statement for determining if we are on the last hop


                                    end%End If statement for whether to show plots or not


                                end %End S Loop - Each Hop Number



        %% Store Ankle Data in Data Structure*


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleAngleSagittal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleTorqueSagittal_IndividualHops);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleAngleSagittal_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleTorqueSagittal_IndividualHopsContactPhase);





                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Frontal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleAngleFrontal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Frontal','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleTorqueFrontal_IndividualHops);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Frontal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleAngleFrontal_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Frontal','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleTorqueFrontal_IndividualHopsContactPhase);





                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Transverse','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleAngleTransverse_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Transverse','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleTorqueTransverse_IndividualHops);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Transverse','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleAngleTransverse_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Transverse','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleTorqueTransverse_IndividualHopsContactPhase);

                              

                                
                                
         %% Store Knee Data in Data Structure


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},KneeAngleSagittal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},KneeTorqueSagittal_IndividualHops);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},KneeAngleSagittal_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},KneeTorqueSagittal_IndividualHopsContactPhase);





                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Frontal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},KneeAngleFrontal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Frontal','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},KneeTorqueFrontal_IndividualHops);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Frontal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},KneeAngleFrontal_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Frontal','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},KneeTorqueFrontal_IndividualHopsContactPhase);






                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Transverse','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},KneeAngleTransverse_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Transverse','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},KneeTorqueTransverse_IndividualHops);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Transverse','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},KneeAngleTransverse_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Transverse','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},KneeTorqueTransverse_IndividualHopsContactPhase);
% 
%                                 KneeTorque_IndividualHopsContactPhase_Table = array2table( [ KneeTorqueSagittal_IndividualHopsContactPhase,KneeTorqueFrontal_IndividualHopsContactPhase,...
%                                     KneeTorqueTransverse_IndividualHopsContactPhase],'VariableNames', Hops_CellArray );
% 
%                                 writetable(KneeTorque_IndividualHopsContactPhase_Table, [ParticipantList{n}, LimbID{a},  'KneeTorque_IndividualHopsContactPhase_Table_',...
%                                     HoppingTrialNumber{q},  '.xlsx'] );


        %% Store Hip Data in Data Structure


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},HipAngleSagittal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},HipTorqueSagittal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},HipAngleSagittal_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},HipTorqueSagittal_IndividualHopsContactPhase);




                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Frontal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},HipAngleFrontal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Frontal','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},HipTorqueFrontal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Frontal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},HipAngleFrontal_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Frontal','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},HipTorqueFrontal_IndividualHopsContactPhase);




                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Transverse','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},HipAngleTransverse_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Transverse','Torque',HoppingRate_ID{b},HoppingTrialNumber{q},HipTorqueTransverse_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Transverse','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},HipAngleTransverse_IndividualHopsContactPhase);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Transverse','Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},HipTorqueTransverse_IndividualHopsContactPhase);
% 
%                                 HipTorque_IndividualHopsContactPhase_Table = array2table( [ HipTorqueSagittal_IndividualHopsContactPhase,HipTorqueFrontal_IndividualHopsContactPhase,...
%                                     HipTorqueTransverse_IndividualHopsContactPhase],'VariableNames', Hops_CellArray )  ;
% 
%                                 writetable(HipTorque_IndividualHopsContactPhase_Table, [ParticipantList{n}, LimbID{a},  'HipTorque_IndividualHopsContactPhase_Table_',...
%                                     HoppingTrialNumber{q},  '.xlsx'] );




%% Store Segment Data in Data Structure



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Shank','Sagittal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},ShankAngleSagittal_IndividualHops);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Shank','Sagittal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},ShankAngleSagittal_IndividualHopsContactPhase);



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Thigh','Sagittal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},ThighAngleSagittal_IndividualHops);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Thigh','Sagittal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},ThighAngleSagittal_IndividualHopsContactPhase);



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Pelvis','Sagittal','Angle',HoppingRate_ID{b},HoppingTrialNumber{q},PelvisAngleSagittal_IndividualHops);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Pelvis','Sagittal','Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},PelvisAngleSagittal_IndividualHopsContactPhase);



                            end%End q Loop - for Hopping Trial Number



%% END B LOOP                                
                        end
                    
            end%End a Loop - for Limb ID
            
        end%End n loop - for Participant ID
        
    end%End m loop - for Group ID    
    
end%End l loop - for Quals vs Final Data


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end











%% !!SECTION 4 - Split Power Data Up Into Individual Hops
  
  %Set some of the RowtoFill variables equal to 1 - these will be used to fill in the matrices
  %initialized in the next three lines
  RowtoFill_JointBehaviorIndex_RateMeans = 1;
  
  


    %Create a prompt so we can tell the code whether we've added any new participants
    ReprocessingDatPrompt =  'Are You Reprocessing Data?' ;

    %Use inputdlg function to create a dialogue box for the prompt created above.
    %First arg is prompt, 2nd is title
    ReprocessingData_Cell = inputdlg( [ '\fontsize{15}' ReprocessingDatPrompt ], 'Are You Reprocessing Data?', [1 150], {'No'} ,CreateStruct);






    %If we are NOT reprocessing data, access JointBehaviorIndex and Power_EntireContactPhase from the
    %data structure
    if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' )

        %Save the Power_EntireContactPhase table in the data structure
        JointBehaviorIndex = David_DissertationDataStructure.Post_Quals.AllGroups.JointBehaviorIndex_Matrix;
        
        
        %Save the Power_EntireContactPhase table in the data structure
        Power_EntireContactPhase = David_DissertationDataStructure.Post_Quals.AllGroups.Power_EntireContactPhase_Matrix;

        %RowtoFill for Power_EntireContactPhase = current number of rows in Power_EntireContactPhase
        RowtoFill_Power_EntireContactPhase = size( Power_EntireContactPhase, 1 );
        
        %RowtoFill for JointBehaviorIndex = current number of rows in JointBehaviorIndex
        RowstoFill_JointBehaviorIndex = size( JointBehaviorIndex, 1);

    %If we ARE reprocessing data, initialize JointBehaviorIndex and Power_EntireContactPhase
    else

      %Initialize matrices to hold data from the entire cohort
      Power_EntireContactPhase = NaN(1, 152);
       JointBehaviorIndex = NaN(1, 11);
    
      RowtoFill_Power_EntireContactPhase = 1;
      RowstoFill_JointBehaviorIndex = 1;

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



%Run this loop once per overarching category of data (data from before Quals versus after Quals)
for l = 1 : numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});
 
    
    
    
 %% Begin M For Loop - Loop Through Groups    
    for m = 1 : numel(GroupList)
        
        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
        ParticipantListDataStructure = getfield(GroupListDataStructure,GroupList{m});
        
        %If Group being processed is ATx, set Participant List, ParticipantMass, LimbID, and HoppingRate_ID_forTable to correspond to the ATx group.  
        %If Group being processed is Controls, set those some variables to the values corresponding
        %to the Control group
        if strcmp( GroupList{m}, 'ATx' )
            
            ParticipantList = ATxParticipantList;
            
            ParticipantMass = ATxParticipantMass;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};
            
            HoppingRate_ID_forTable = [0, 2, 2.3];

            
        else
            
            ParticipantList = ControlParticipantList;
            
            ParticipantMass = ControlParticipantMass;
            
            LimbID = {'LeftLimb','RightLimb'};

            HoppingRate_ID_forTable = [0, 2, 2.3];
            
        end
        
        


        
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


            elseif strcmp( cell2mat( ShowAnyPlots_Cell ), 'No' ) || strcmp( cell2mat( ShowAnyPlots_Cell ), 'N' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'Yes' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'Y' )
                    
                ShowPlots_Cell = {'No'};

            end
            

            %If you have NOT added Participant N Data, add it to the data structure
            if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )
            
            %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
            ListofDataTypes_DataStructure = getfield(ParticipantListDataStructure,ParticipantList{n});
            
            
            
            %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %tables, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{n}, 'ATx07'  )
             
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
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx08'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx10 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx10'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx10 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx12'  )
                
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
                

                
                
            elseif strcmp( ParticipantList{n}, 'ATx17'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx10 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
             


            
            elseif strcmp( ParticipantList{n}, 'ATx18'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx18 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];




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
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx21'  )
             
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
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx24'  )
                
                LimbID = { 'InvolvedLimb', 'NonInvolvedLimb' };
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx24 only has two rates
                HoppingRate_ID = { 'TwoHz', 'TwoPoint3Hz'};   
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 2, 2.3 ];    
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx25'  )
             
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
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx27'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx10 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx34'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx10 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx36'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx36 has 3 hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx38'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx38 has 3 hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                
            elseif strcmp( ParticipantList{n}, 'ATx41'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx41 has 3 hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx44'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx44 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx50'  )
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx50 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                

            elseif strcmp( ParticipantList{n}, 'HC11'  )
                
                %Process only the right limb of HC11
                LimbID = { 'RightLimb', 'LeftLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = {  'RightLimb', 'LeftLimb' };
                
                %HC11 has only the 2.0 and 2.3 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{ n }, 'HC08'  ) ||  strcmp( ParticipantList{ n }, 'HC17'  ) || strcmp( ParticipantList{ n }, 'HC19'  ) || strcmp( ParticipantList{ n }, 'HC21'  ) ||...
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
            
            
            %Set ParticipantNMass to be the mass for Participant N
            ParticipantNMass = ParticipantMass(n);
            
            %Calculate weight for Participant N
            ParticipantNWeight = ParticipantNMass.*9.81;
                
             
           
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ n }, 'HP08' )
                
                MoCapSampHz = 150;
                
                
            elseif strcmp( ParticipantList{ n }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
                
                
                
%% Begin A For Loop - Loop Through Limbs

            for a = 1 : numel(LimbID)
                




                
                %Use get field to create a new data structure containing the list of limbs. Stored under the 4th field of the structure (the list of data categories)
                Listof_LimbIDsforIndexing_DataStructure = getfield(ListofDataTypes_DataStructure,'UseforIndexingIntoData');

                %Index into same data structure, but want to pull out the original data table
                Listof_LimbIDsforOriginalDataTable_DataStructure = getfield(ListofDataTypes_DataStructure,'HoppingKinematicsKinetics');
                
                %Index into same data structure, but want to pull out the individual hops
                Listof_LimbIDsforIndividualHops_DataStructure = getfield(ListofDataTypes_DataStructure,'IndividualHops');
                    
                %Create a new data structure containing data for indexing into variables. The data
                %structure contains all data corresponding to Limb A
                VariablesInHoppingRates_DataStructure = getfield(Listof_LimbIDsforIndexing_DataStructure,LimbID{a});
                
                %Create a new data structure containing the Visual 3D data tables for Limb A
                VariablesInHoppingRates_forOriginalDataTable_DataStructure = getfield(Listof_LimbIDsforOriginalDataTable_DataStructure,LimbID{a});
                
                %Create a new data structure containing the data separated into individual hops, for
                %Limb A
                VariablesInHoppingRates_forIndividualHops_DataStructure = getfield(Listof_LimbIDsforIndividualHops_DataStructure,LimbID{a});



                        %How long are the flight and contact phases? In terms of GRF sampling
                        %frequency. One row per hop
                        LengthofFlightPhase_GRFSamplingHz = NaN(4, 1);
                        LengthofContactPhase_GRFSamplingHz = NaN(4, 1);

                        %How many data points are there per hop? In terms of motion capture sampling
                        %Hz then EMG sampling Hz. One row per hop
                        NumEl_SthHop_MoCapSamplingHz = NaN(4, 1);
                        NumEl_SthHop_EMGSamplingHz = NaN(4, 1);

                        %What are the frame numbers corresponding to the beginning and end of the
                        %ground contact phase? In terms of motion capture sampling Hz
                        GContactBegin_MoCapFrameNumbers = NaN(4, 1);
                        GContactEnd_forContactPhase_MoCapFrameNumbers = NaN(4, 1);

                        %What are the frame numbers corresponding to the beginning and end of the
                        %ground contact phase? In terms of motion capture sampling Hz
                        GContactBegin_EMGFrameNumbers = NaN(4, 1);
                        GContactEnd_EMGFrameNumbers = NaN(4, 1);

                        %Find the first data point of each hop - this corresponds to beginning of flight phase. In terms of motion capture sampling
                        %Hz, then EMG sampling Hz. Will use this to create a vector containing the
                        %time points for  each hop
                        FirstDataPoint_SthHop_MoCapSamplingHz = NaN(4, 1);
                        FirstDataPoint_SthHop_EMGSamplingHz = NaN(4, 1);

                        %Find the last data point of each hop - this corresponds to the end of the ground contact phase. In terms
                        %of motion capture, EMG, and GRF sampling Hz. Will use this to create a vector containing the
                        %time points for the ground contact phase of each hop
                        LastDataPoint_SthHop_MoCapSamplingHz = NaN(4, 1);
                        LastDataPoint_SthHop_EMGSamplingHz = NaN(4, 1);
                        LastDataPoint_SthHop_GRFSamplingHz = NaN(4, 1);

                        %How many data points are there for the ground contact phase of each hop?
                        NumEl_SthHopContactPhase_MoCapSamplingHz = NaN(4, 1);
                        NumEl_SthHopContactPhase_EMGSamplingHz = NaN(4, 1);
                        NumEl_SthHopContactPhase_GRFSamplingHz = NaN(4, 1);

                        
                        PeakvGRF = NaN(4, 1);
                        PeakvGRF_FrameNumber = NaN(4, 1);
                        PeakvGRF_MoCapFrameNumber = NaN(4, 1);

                        PeakKneeFlexion = NaN(4, 1);
                        PeakKneeFlexion_FrameNumber = NaN(4, 1);
                        
                        MinL5S1 = NaN(4,1);

                        MinCOGvertical = NaN(4,1);
                        
                        
                        AllJointsPositive = NaN(1, 1);
                        AllJointsNegative = NaN(1, 1);


                        TotalAnkle_MEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,2);
                        TotalKnee_MEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,2);
                        TotalHip_MEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,2);

                        TotalLimb_MEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,2);

                        Ankle_PercentMEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,2);
                        Knee_PercentMEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,2);
                        Hip_PercentMEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,2);




                        TotalAnkle_MEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,2);
                        TotalKnee_MEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,2);
                        TotalHip_MEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,2);

                        TotalLimb_MEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,2);

                        Ankle_PercentMEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,2);
                        Knee_PercentMEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,2);
                        Hip_PercentMEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,2);




                        TotalAnkle_MEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,2);
                        TotalKnee_MEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,2);
                        TotalHip_MEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,2);

                        TotalLimb_MEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,2);

                        Ankle_PercentMEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,2);
                        Knee_PercentMEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,2);
                        Hip_PercentMEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,2);




                        TotalAnkle_MEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,2);
                        TotalKnee_MEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,2);
                        TotalHip_MEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,2);

                        TotalLimb_MEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,2);

                        Ankle_PercentMEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,2);
                        Knee_PercentMEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,2);
                        Hip_PercentMEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,2);

                        
     
%% Begin B For Loop - Loop Through Hopping Rates      

                        for b = 1 : numel( HoppingRate_ID)
                    
                            
                            %Create a new data structure containing data for indexing into variables. The data
                            %structure contains all data corresponding to Hopping Rate B
                            IndexingDataWithinHoppingRateB_DataStructure =  getfield( VariablesInHoppingRates_DataStructure, HoppingRate_ID{b} );

                            %Create a new data structure containing the Visual 3D data tables for
                            %Hopping Rate B
                            DataWithinMTU_IDforOriginalDataTable_DataStructure =  getfield( VariablesInHoppingRates_forOriginalDataTable_DataStructure, HoppingRate_ID{b} );

                            %Create a new data structure containing the data separated into individual hops, for
                            %Hopping Rate B
                            DataWithinMTU_IDforIndividualHops_DataStructure =   VariablesInHoppingRates_forIndividualHops_DataStructure;



     %% Begin Q For Loop - Loop Through Hopping Bouts                      

                            for q = 1 : numel(HoppingTrialNumber)


%% Initialize Variables For Each Hop

                                AnklePowerSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                AnkleWorkSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber)); 
                                AnklePowerSagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,numel(HoppingTrialNumber));
                                AnklePowerSagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,numel(HoppingTrialNumber));
                                AnklePowerSagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,numel(HoppingTrialNumber));
                                AnklePowerSagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,numel(HoppingTrialNumber));
                                AnklePowerSagittal_BrakingPhase_MinL5S1AsReference = NaN(4,numel(HoppingTrialNumber));
                                AnklePowerSagittal_PropulsionPhase_MinL5S1AsReference = NaN(4,numel(HoppingTrialNumber));
                                AnklePowerSagittal_BrakingPhase_AllJointsNegative = NaN(4,numel(HoppingTrialNumber));
                                AnklePowerSagittal_PropulsionPhase_AllJointsPositive = NaN(4,numel(HoppingTrialNumber));
                                AnkleMEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(1,1);
                                AnkleMEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(1,1);
                                AnkleMEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(1,1);
                                AnkleMEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(1,1);

                                KneePowerSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneeWorkSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                KneePowerSagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,numel(HoppingTrialNumber));
                                KneePowerSagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,numel(HoppingTrialNumber));
                                KneePowerSagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,numel(HoppingTrialNumber));
                                KneePowerSagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,numel(HoppingTrialNumber));
                                KneeMEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(1,1);
                                KneeMEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(1,1);
                                KneeMEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(1,1);
                                KneeMEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(1,1);

                                HipPowerSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                HipWorkSagittal_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                HipPowerSagittal_BrakingPhase_PeakvGRFAsReference = NaN(4,numel(HoppingTrialNumber));
                                HipPowerSagittal_PropulsionPhase_PeakvGRFAsReference = NaN(4,numel(HoppingTrialNumber));
                                HipPowerSagittal_BrakingPhase_PeakKneeFlexReference = NaN(4,numel(HoppingTrialNumber));
                                HipPowerSagittal_PropulsionPhase_PeakKneeFlexReference = NaN(4,numel(HoppingTrialNumber));
                                HipMEESagittal_BrakingPhase_PeakvGRFAsReference = NaN(1,1);
                                HipMEESagittal_PropulsionPhase_PeakvGRFAsReference = NaN(1,1);
                                HipMEESagittal_BrakingPhase_PeakKneeFlexReference = NaN(1,1);
                                HipMEESagittal_PropulsionPhase_PeakKneeFlexReference = NaN(1,1);

                                CoMVerticalPosition_IndividualHops = NaN(1,1);
                                L5S1VerticalPosition_IndividualHops = NaN(1,1);

                                VGRF_IndividualHops_DownSampled = NaN(4,numel(HoppingTrialNumber));
                                VGRF_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                VGRF_IndividualHops_Normalized = NaN(4,numel(HoppingTrialNumber));

                                NumEl_SthHop = NaN(4,1);
                                NumEl_SthHop_MoCap = NaN(4,1);
                                NumEl_SthHop_EMG = NaN(4,1);
                                LengthofFlightPhase_MoCapSamplingHz = NaN(4,1);
                                LengthofFlightPhase_NonTruncated_MoCapSampHz = NaN(4,1);
                                LengthofFlightPhase_Frames_GRFSampHz = NaN(4,1);
                                LengthofFlightPhase_Seconds = NaN(4,1);
                                LengthofContactPhase_Frames_MoCapSampHz = NaN(4,1);
                                LengthofContactPhase_Seconds = NaN(4,1);
                                LengthofBrakingPhase_Seconds =  NaN(4,1);
                                LengthofPropulsionPhase_Seconds = NaN(4,1);

                                VGRF_IndividualHops_ContactPhase = NaN(3,numel(HoppingTrialNumber));

                                VGRF_IndividualHops_ContactPhase_Normalized = NaN(3,numel(HoppingTrialNumber));

                                AnklePowerSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneePowerSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipPowerSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));

                                AnkleAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngleSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                
                                AnkleAngVelSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngVelSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngVelSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                
                                AnkleTorqueSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeTorqueSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipTorqueSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));




                                AnkleAngleFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngleFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngleFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                
                                AnkleAngVelFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngVelFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngVelFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                
                                AnkleTorqueFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeTorqueFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipTorqueFrontal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));



                                AnkleAngleTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngleTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngleTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                
                                AnkleAngVelTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeAngVelTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipAngVelTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                
                                AnkleTorqueTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                KneeTorqueTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                HipTorqueTransverse_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));


                                FootAngVelSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                ShankAngVelSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                ThighAngVelSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                PelvisAngVelSagittal_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                



                                CoMVerticalPosition_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));
                                L5S1VerticalPosition_IndividualHopsContactPhase = NaN(3,numel(HoppingTrialNumber));

                                
                                AnklePowerSagittal_OnlyPositive_PeakvGRFAsReference = NaN(3,1);
                                AnklePowerSagittal_OnlyNegative_PeakvGRFAsReference = NaN(3,1);
                                KneePowerSagittal_OnlyPositive_PeakvGRFAsReference = NaN(3,1);
                                KneePowerSagittal_OnlyNegative_PeakvGRFAsReference = NaN(3,1);
                                HipPowerSagittal_OnlyPositive_PeakvGRFAsReference = NaN(3,1);
                                HipPowerSagittal_OnlyNegative_PeakvGRFAsReference = NaN(3,1);

                                
                                AnklePowerSagittal_OnlyPositive_PeakKneeFlexAsReference = NaN(3,1);
                                AnklePowerSagittal_OnlyNegative_PeakKneeFlexAsReference = NaN(3,1);
                                KneePowerSagittal_OnlyPositive_PeakKneeFlexAsReference = NaN(3,1);
                                KneePowerSagittal_OnlyNegative_PeakKneeFlexAsReference = NaN(3,1);
                                HipPowerSagittal_OnlyPositive_PeakKneeFlexAsReference = NaN(3,1);
                                HipPowerSagittal_OnlyNegative_PeakKneeFlexAsReference = NaN(3,1);
                                
                                
                                AnklePowerSagittal_OnlyPositive_MinL5S1AsReference = NaN(3,1);
                                AnklePowerSagittal_OnlyNegative_MinL5S1AsReference = NaN(3,1);
                                KneePowerSagittal_OnlyPositive_MinL5S1AsReference = NaN(3,1);
                                KneePowerSagittal_OnlyNegative_MinL5S1AsReference = NaN(3,1);
                                HipPowerSagittal_OnlyPositive_MinL5S1AsReference = NaN(3,1);
                                HipPowerSagittal_OnlyNegative_MinL5S1AsReference = NaN(3,1);
                                
                                
                                
                                AnklePowerSagittal_OnlyPositive_AllJointsPos = NaN(3,1);
                                AnklePowerSagittal_OnlyNegative_AllJointsNeg = NaN(3,1);
                                KneePowerSagittal_OnlyPositive_AllJointsPos = NaN(3,1);
                                KneePowerSagittal_OnlyNegative_AllJointsNeg = NaN(3,1);
                                HipPowerSagittal_OnlyPositive_AllJointsPos = NaN(3,1);
                                HipPowerSagittal_OnlyNegative_AllJointsNeg = NaN(3,1);
                                
                                
                                

                                 MinLengthofFlightPhase_MoCapSamplingHz = NaN(2,1);
                                 MinLengthofFlightPhase_EMGSamplingHz = NaN(2,1); 

                                 
                                 Length_AllJointsNegativePowerSagittal_PeakvGRFAsReference = NaN(4,1);
                                Length_AllJointsPositivePowerSagittal_PeakvGRFAsReference = NaN(4,1);
                                Length_AllJointsNegativePowerSagittal_PeakKneeFlexAsReference = NaN(4,1);
                                Length_AllJointsPositivePowerSagittal_PeakKneeFlexAsReference = NaN(4,1);

                                Length_BrakingPhase_PeakvGRFAsReference = NaN(4,1);
                                Length_PropulsionPhase_PeakvGRFAsReference = NaN(4,1);

                                Length_BrakingPhase_PeakKneeFlexAsReference = NaN(4,1);
                                Length_PropulsionPhase_PeakKneeFlexAsReference = NaN(4,1);

                                TotalNegativePower_Ankle_EntireContactPhase = NaN(4,1);
                                TotalPositivePower_Ankle_EntireContactPhase = NaN(4,1);
                                TotalNegativePower_Knee_EntireContactPhase= NaN(4,1);
                                TotalPositivePower_Knee_EntireContactPhase = NaN(4,1);
                                TotalNegativePower_Hip_EntireContactPhase = NaN(4,1);
                                TotalPositivePower_Hip_EntireContactPhase = NaN(4,1);

                                TotalNegativePower_Ankle_PeakvGRFAsReference = NaN(4,1);
                                TotalNegativePower_Knee_PeakvGRFAsReference = NaN(4,1);
                                TotalNegativePower_Hip_PeakvGRFAsReference = NaN(4,1);

                                TotalPositivePower_Ankle_PeakvGRFAsReference = NaN(4,1);
                                TotalPositivePower_Knee_PeakvGRFAsReference = NaN(4,1);
                                TotalPositivePower_Hip_PeakvGRFAsReference = NaN(4,1);

                                TotalNegativePower_Ankle_PeakKneeFlexAsReference = NaN(4,1);
                                TotalNegativePower_Knee_PeakKneeFlexAsReference = NaN(4,1);
                                TotalNegativePower_Hip_PeakKneeFlexAsReference = NaN(4,1);

                                TotalPositivePower_Ankle_PeakKneeFlexAsReference = NaN(4,1);
                                TotalPositivePower_Knee_PeakKneeFlexAsReference = NaN(4,1);
                                TotalPositivePower_Hip_PeakKneeFlexAsReference = NaN(4,1); 

                                TotalNegativePower_AllJoints_EntireContactPhase = NaN(4,1);
                                TotalNegativePower_AllJoints_PeakvGRFAsReference = NaN(4,1);
                                TotalNegativePower_AllJoints_PeakKneeFlexAsReference = NaN(4,1);


                                TotalPositivePower_AllJoints_EntireContactPhase = NaN(4,1);
                                TotalPositivePower_AllJoints_PeakvGRFAsReference = NaN(4,1);
                                TotalPositivePower_AllJoints_PeakKneeFlexAsReference = NaN(4,1);


                                  PercentNegativePower_Ankle_EntireContactPhase  = NaN(4,1);        
                                  PercentNegativePower_Knee_EntireContactPhase  = NaN(4,1); 
                                  PercentNegativePower_Hip_EntireContactPhase  = NaN(4,1); 


                                  PercentPositivePower_Ankle_EntireContactPhase  = NaN(4,1);        
                                  PercentPositivePower_Knee_EntireContactPhase  = NaN(4,1); 
                                  PercentPositivePower_Hip_EntireContactPhase  = NaN(4,1); 



                                  PercentNegativePower_Ankle_PeakvGRFAsReference  = NaN(4,1);        
                                  PercentNegativePower_Knee_PeakvGRFAsReference  = NaN(4,1); 
                                  PercentNegativePower_Hip_PeakvGRFAsReference  = NaN(4,1); 

                                  PercentPositivePower_Ankle_PeakvGRFAsReference  = NaN(4,1);        
                                  PercentPositivePower_Knee_PeakvGRFAsReference  = NaN(4,1); 
                                  PercentPositivePower_Hip_PeakvGRFAsReference  = NaN(4,1);   


                                  PercentNegativePower_Ankle_PeakKneeFlexAsReference  = NaN(4,1);        
                                  PercentNegativePower_Knee_PeakKneeFlexAsReference  = NaN(4,1); 
                                  PercentNegativePower_Hip_PeakKneeFlexAsReference  = NaN(4,1); 

                                  PercentPositivePower_Ankle_PeakKneeFlexAsReference  = NaN(4,1);        
                                  PercentPositivePower_Knee_PeakKneeFlexAsReference  = NaN(4,1); 
                                  PercentPositivePower_Hip_PeakKneeFlexAsReference  = NaN(4,1);                          


                                  AnkleWorkSagittal_BrakingPhase_PeakvGRFAsReference  = NaN(4,1);
                                  KneeWorkSagittal_BrakingPhase_PeakvGRFAsReference  = NaN(4,1);
                                  HipWorkSagittal_BrakingPhase_PeakvGRFAsReference  = NaN(4,1);

                                  AnkleWorkSagittal_PropulsionPhase_PeakvGRFAsReference  = NaN(4,1);
                                  KneeWorkSagittal_PropulsionPhase_PeakvGRFAsReference  = NaN(4,1);
                                  HipWorkSagittal_PropulsionPhase_PeakvGRFAsReference  = NaN(4,1);


                                  AnkleWorkSagittal_BrakingPhase_PeakKneeFlexReference  = NaN(4,1);
                                  KneeWorkSagittal_BrakingPhase_PeakKneeFlexReference  = NaN(4,1);
                                  HipWorkSagittal_BrakingPhase_PeakKneeFlexReference  = NaN(4,1);

                                  AnkleWorkSagittal_PropulsionPhase_PeakKneeFlexReference  = NaN(4,1);
                                  KneeWorkSagittal_PropulsionPhase_PeakKneeFlexReference  = NaN(4,1);
                                  HipWorkSagittal_PropulsionPhase_PeakKneeFlexReference  = NaN(4,1);

                                  AnkleWork_EntireContactPhase_InterpolatedforWorkLoop  = NaN(4,1);
                                  AnkleWork_EntireContactPhase = NaN(4,1);

                                  KneeWork_EntireContactPhase_InterpolatedforWorkLoop  = NaN(4,1);
                                  KneeWork_EntireContactPhase = NaN(4,1);

                                  HipWork_EntireContactPhase_InterpolatedforWorkLoop  = NaN(4,1);
                                  HipWork_EntireContactPhase = NaN(4,1);

                                  DesiredLengthofWorkData = NaN(4,1);
                                  
                                  TotalAnkleNegativeWork_AllPeriodsAcrossContactPhase  = NaN(4,1);
                                  TotalAnklePositiveWork_AllPeriodsAcrossContactPhase  = NaN(4,1);
                                  TotalKneeNegativeWork_AllPeriodsAcrossContactPhase  = NaN(4,1);
                                  TotalKneePositiveWork_AllPeriodsAcrossContactPhase  = NaN(4,1);
                                  TotalHipNegativeWork_AllPeriodsAcrossContactPhase  = NaN(4,1);
                                  TotalHipPositiveWork_AllPeriodsAcrossContactPhase  = NaN(4,1);
                                  
                                  LengthofAnkleAbsorption_Sec  = NaN(4,1);
                                  LengthofAnkleGeneration_Sec  = NaN(4,1);
                                  LengthofKneeAbsorption_Sec  = NaN(4,1);
                                  LengthofKneeGeneration_Sec  = NaN(4,1);
                                  LengthofHipAbsorption_Sec  = NaN(4,1);
                                  LengthofHipGeneration_Sec  = NaN(4,1);
                                  
                                  AnkleWorkRatio_EntireContactPhase  = NaN(4,1);
                                  KneeWorkRatio_EntireContactPhase  = NaN(4,1);
                                  HipWorkRatio_EntireContactPhase  = NaN(4,1);
                                  
                                  TotalAnkleWork_EntireContactPhase = NaN(4, 1);
                                  TotalKneeWork_EntireContactPhase = NaN(4, 1);
                                  TotalHipWork_EntireContactPhase = NaN(4, 1);
                                  
                                  TotalAnkleSagittalTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  TotalKneeSagittalTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  TotalHipSagittalTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  
                                  TotalAnkleFrontalTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  TotalKneeFrontalTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  TotalHipFrontalTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  
                                  TotalAnkleTransverseTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  TotalKneeTransverseTorqueImpulse_EntireContactPhase = NaN(4, 1);
                                  TotalHipTransverseTorqueImpulse_EntireContactPhase = NaN(4, 1);

                                AnkleContactMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeContactMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipContactMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);


                                AnkleAbsorptionMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeAbsorptionMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipAbsorptionMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                AnkleGenerationMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeGenerationMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipGenerationMEE = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
 

                                AnkleWork_Propulsion_AbsorptionNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeWork_Propulsion_AbsorptionNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipWork_Propulsion_AbsorptionNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                WholeLimbWork_Propulsion_AbsorptionNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleWorkContribution_Propulsion_AbsorptionNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeWorkContribution_Propulsion_AbsorptionNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipWorkContribution_Propulsion_AbsorptionNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                AnkleWork_Braking_GenerationNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeWork_Braking_GenerationNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipWork_Braking_GenerationNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                WholeLimbWork_Braking_GenerationNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleWorkContribution_Braking_GenerationNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeWorkContribution_Braking_GenerationNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipWorkContribution_Braking_GenerationNeutralized = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);




                                AnkleContactWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeContactWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipContactWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnkleAbsorptionWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeAbsorptionWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipAbsorptionWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                AnkleGenerationWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeGenerationWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipGenerationWork = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                

                                LimbAbsorptionWorkRatio = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                LimbGenerationWorkRatio = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnkleContactSagittalTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeContactSagittalTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipContactSagittalTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnkleContactFrontalTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeContactFrontalTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipContactFrontalTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnkleContactTransverseTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeContactTransverseTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipContactTransverseTorqueImpulse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnkleTorqueImpulse_Braking_Sagittal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Braking_Frontal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Braking_Transverse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Braking_Sagittal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Braking_Frontal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Braking_Transverse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Braking_Sagittal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Braking_Frontal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Braking_Transverse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                AnkleTorqueImpulse_Propulsion_Sagittal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Propulsion_Frontal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Propulsion_Transverse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Propulsion_Sagittal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Propulsion_Frontal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Propulsion_Transverse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Propulsion_Sagittal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Propulsion_Frontal = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Propulsion_Transverse = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);



                                AnkleTorqueImpulse_Braking_Sagittal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Braking_Frontal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Braking_Transverse_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Braking_Sagittal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Braking_Frontal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Braking_Transverse_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Braking_Sagittal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Braking_Frontal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Braking_Transverse_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                AnkleTorqueImpulse_Propulsion_Sagittal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Propulsion_Frontal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnkleTorqueImpulse_Propulsion_Transverse_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Propulsion_Sagittal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Propulsion_Frontal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneeTorqueImpulse_Propulsion_Transverse_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Propulsion_Sagittal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Propulsion_Frontal_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipTorqueImpulse_Propulsion_Transverse_NoFlexTorq = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                
                                WholeLimbContactMEE= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                WholeLimbAbsorptionMEE= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                WholeLimbGenerationMEE= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnklePercentMEEContact= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneePercentMEEContact= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipPercentMEEContact= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnklePercentMEEAbsorption= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneePercentMEEAbsorption= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipPercentMEEAbsorption= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                
                                AnklePercentMEEGeneration= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneePercentMEEGeneration= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                HipPercentMEEGeneration= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                 

                                AnkleandKneeContactMEE= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnklePercentMEE_ofAnkleandKneeMEE_Contact = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneePercentMEE_ofAnkleandKneeMEE_Contact  = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                AnkleandKneeAbsorptionMEE= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnklePercentMEE_ofAnkleandKneeMEE_Braking = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneePercentMEE_ofAnkleandKneeMEE_Braking = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                AnkleandKneeGenerationMEE= NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                AnklePercentMEE_ofAnkleandKneeMEE_Propulsion = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);
                                KneePercentMEE_ofAnkleandKneeMEE_Propulsion = NaN( numel(GContactBegin_MoCapFrameNumbers(:,q)), 1);

                                
                                 
                                    %Initialize the variables for holding the ankle, knee, and hip
                                    %data for the absorption and generaiton phases
                                    AnklePower_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneePower_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipPower_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnklePower_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneePower_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipPower_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );

                                    AnkleSagittalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeSagittalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipSagittalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleSagittalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeSagittalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipSagittalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    
                                    AnkleFrontalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeFrontalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipFrontalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleFrontalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeFrontalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipFrontalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    
                                    
                                    AnkleTransverseAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeTransverseAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipTransverseAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleTransverseAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeTransverseAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipTransverseAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    
                                    AnkleSagittalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeSagittalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipSagittalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeSagittalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipSagittalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    
                                    AnkleFrontalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeFrontalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipFrontalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleFrontalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeFrontalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipFrontalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    
                                    
                                    AnkleTransverseAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeTransverseAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipTransverseAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleTransverseAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeTransverseAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipTransverseAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );




                                    AverageAnkleAbsorptionAngVel_Sagittal= NaN( 1, 1 );
                                    AverageAnkleAbsorptionAngVel_Frontal= NaN( 1, 1 );
                                    AverageAnkleAbsorptionAngVel_Transverse= NaN( 1, 1 );

                                    AverageKneeAbsorptionAngVel_Sagittal= NaN( 1, 1 );
                                    AverageKneeAbsorptionAngVel_Frontal= NaN( 1, 1 );
                                    AverageKneeAbsorptionAngVel_Transverse= NaN( 1, 1 );

                                    AverageHipAbsorptionAngVel_Sagittal= NaN( 1, 1 );
                                    AverageHipAbsorptionAngVel_Frontal= NaN( 1, 1 );
                                    AverageHipAbsorptionAngVel_Transverse= NaN( 1, 1 );


                                    AverageAnkleGenerationAngVel_Sagittal= NaN( 1, 1 );
                                    AverageAnkleGenerationAngVel_Frontal= NaN( 1, 1 );
                                    AverageAnkleGenerationAngVel_Transverse= NaN( 1, 1 );

                                    AverageKneeGenerationAngVel_Sagittal= NaN( 1, 1 );
                                    AverageKneeGenerationAngVel_Frontal= NaN( 1, 1 );
                                    AverageKneeGenerationAngVel_Transverse= NaN( 1, 1 );

                                    AverageHipGenerationAngVel_Sagittal= NaN( 1, 1 );
                                    AverageHipGenerationAngVel_Frontal= NaN( 1, 1 );
                                    AverageHipGenerationAngVel_Transverse= NaN( 1, 1 );
                                    

                                    AnkleSagittalRoM_BrakingPhase = NaN( 1, 1 );
                                    KneeSagittalRoM_BrakingPhase = NaN( 1, 1 );
                                    HipSagittalRoM_BrakingPhase = NaN( 1, 1 );

                                    AnkleSagittalRoM_PropulsionPhase = NaN( 1, 1 );
                                    KneeSagittalRoM_PropulsionPhase = NaN( 1, 1 );
                                    HipSagittalRoM_PropulsionPhase = NaN( 1, 1 );

                                    PeakDF_BrakingPhase = NaN( 1, 1 );
                                    PeakKneeFlex_BrakingPhase = NaN( 1, 1 );
                                    PeakHipFlex_BrakingPhase = NaN( 1, 1 );

                                    PeakPF_PropulsionPhase = NaN( 1, 1 );
                                    PeakKneeExt_PropulsionPhase = NaN( 1, 1 );
                                    PeakHipExt_PropulsionPhase = NaN( 1, 1 );

                                    TimetoPeakDF_BrakingPhase = NaN( 1, 1 );
                                    TimetoPeakKneeFlex_BrakingPhase = NaN( 1, 1 );
                                    TimetoPeakHipFlex_BrakingPhase = NaN( 1, 1 );
                                    
                                    TimetoPeakPF_PropulsionPhase = NaN( 1, 1 );
                                    TimetoPeakKneeExt_PropulsionPhase = NaN( 1, 1 );
                                    TimetoPeakHipExt_PropulsionPhase = NaN( 1, 1 );

                                    TimetoPeakDFAngVel_BrakingPhase = NaN( 1, 1 );
                                    TimetoPeakKneeFlexAngVel_BrakingPhase = NaN( 1, 1 );
                                    TimetoPeakHipFlexAngVel_BrakingPhase = NaN( 1, 1 );
                                    
                                    TimetoPeakPFAngVel_PropulsionPhase = NaN( 1, 1 );
                                    TimetoPeakKneeExtAngVel_PropulsionPhase = NaN( 1, 1 );
                                    TimetoPeakHipExtAngVel_PropulsionPhase = NaN( 1, 1 );


                                    AnkleAngleAtPeakAngVel_BrakingPhase = NaN( 1, 1 );
                                    KneeAngleAtPeakAngVel_BrakingPhase = NaN( 1, 1 );
                                    HipAngleAtPeakAngVel_BrakingPhase = NaN( 1, 1 );

                                    AnkleAngleAtPeakAngVel_PropulsionPhase = NaN( 1, 1 );
                                    KneeAngleAtPeakAngVel_PropulsionPhase = NaN( 1, 1 );
                                    HipAngleAtPeakAngVel_PropulsionPhase = NaN( 1, 1 );


                                    AnkleInitialContactAngle = NaN( 1, 1 );
                                    KneeInitialContactAngle = NaN( 1, 1 );
                                    HipInitialContactAngle = NaN( 1, 1 );
    
                                    AnkleInitialPropulsionPhaseAngle = NaN( 1, 1 );
                                    KneeInitialPropulsionPhaseAngle = NaN( 1, 1 );
                                    HipInitialPropulsionPhaseAngle = NaN( 1, 1 );

                                    
                                    AnkleSagittalTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeSagittalTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipSagittalTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleSagittalTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeSagittalTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipSagittalTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );

                                    
                                    AnkleFrontalTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeFrontalTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipFrontalTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleFrontalTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeFrontalTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipFrontalTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );

           
                                    AnkleTransverseTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeTransverseTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipTransverseTorque_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    AnkleTransverseTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    KneeTransverseTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    HipTransverseTorque_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );

                                    
                                    AnkleAbsorptionAngVel_Sagittal_TempVector = NaN( 1, 1 );
                                    KneeAbsorptionAngVel_Sagittal_TempVector = NaN( 1, 1 );
                                    HipAbsorptionAngVel_Sagittal_TempVector = NaN( 1, 1 );

                                    AnkleGenerationAngVel_Sagittal_TempVector = NaN( 1, 1 );
                                    KneeGenerationAngVel_Sagittal_TempVector = NaN( 1, 1 );
                                    HipGenerationAngVel_Sagittal_TempVector = NaN( 1, 1 );


                                    AnkleAbsorptionAngVel_Frontal_TempVector = NaN( 1, 1 );
                                    KneeAbsorptionAngVel_Frontal_TempVector = NaN( 1, 1 );
                                    HipAbsorptionAngVel_Frontal_TempVector = NaN( 1, 1 );

                                    AnkleGenerationAngVel_Frontal_TempVector = NaN( 1, 1 );
                                    KneeGenerationAngVel_Frontal_TempVector = NaN( 1, 1 );
                                    HipGenerationAngVel_Frontal_TempVector = NaN( 1, 1 );


                                    AnkleAbsorptionAngVel_Transverse_TempVector = NaN( 1, 1 );
                                    KneeAbsorptionAngVel_Transverse_TempVector = NaN( 1, 1 );
                                    HipAbsorptionAngVel_Transverse_TempVector = NaN( 1, 1 );

                                    AnkleGenerationAngVel_Transverse_TempVector = NaN( 1, 1 );
                                    KneeGenerationAngVel_Transverse_TempVector = NaN( 1, 1 );
                                    HipGenerationAngVel_Transverse_TempVector = NaN( 1, 1 );
                                    
                                     LengthofBrakingPhase = NaN( 1, 1);
                                     LengthofPropulsionPhase = NaN( 1, 1);
                                     
                                     FrameofMinL5S1Position_BeginPropulsion = NaN( 2, 1 );
                                    FrameofMinL5S1Position_EndBraking = NaN( 2, 1);
                                    FrameofMinL5S1Position_EndBraking_GRFSampHz = NaN( 2, 1);
                                    FrameofMinL5S1Position_BeginPropulsion_GRFSampHz = NaN( 2, 1);

                                    HoppingHeight = NaN( 2, 1);
                                    LengthofContactPhase_Frames_GRFSampHz = NaN( 1);
                                    LengthofHopCycle_sec = NaN( 1);
                                    HopFrequency = NaN( 1);



                                    ShankSagittalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    ThighSagittalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    PelvisSagittalAngle_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    ShankSagittalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    ThighSagittalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    PelvisSagittalAngle_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );

                                    ShankSagittalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    ThighSagittalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    ShankSagittalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    ThighSagittalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    
                                    ShankFrontalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    ThighFrontalAngVel_BrakingPhase_L5S1AsReference = NaN( 1, 1 );
                                    ShankFrontalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );
                                    ThighFrontalAngVel_PropulsionPhase_L5S1AsReference = NaN( 1, 1 );

                                    WholeLimbWork_BrakingPhase = NaN( 1, 1 );
                                    AnkleWorkContribution_BrakingPhase = NaN( 1, 1 );
                                    KneeWorkContribution_BrakingPhase = NaN( 1, 1 );
                                    HipWorkContribution_BrakingPhase = NaN( 1, 1 );
                                    WholeLimbWork_PropulsionPhase = NaN( 1, 1 );
                                    AnkleWorkContribution_PropulsionPhase = NaN( 1, 1 );
                                    KneeWorkContribution_PropulsionPhase = NaN( 1, 1 );
                                    HipWorkContribution_PropulsionPhase = NaN( 1, 1 );
                                

                                    TotalLimbSupportMoment_Braking_NoFlexorTorque = NaN( 1, 1 );
                                    TotalAnkleSupportMoment_Braking_NoFlexorTorque = NaN( 1, 1 );
                                    TotalKneeSupportMoment_Braking_NoFlexorTorque = NaN( 1, 1 );
                                    TotalHipSupportMoment_Braking_NoFlexorTorque = NaN( 1, 1 );
                                    AnkleSupportMomentContribution_Braking_NoFlexorTorque = NaN( 1, 1 );
                                    KneeSupportMomentContribution_Braking_NoFlexorTorque = NaN( 1, 1 );
                                    HipSupportMomentContribution_Braking_NoFlexorTorque = NaN( 1, 1 );
                                   

                                    LimbSupportMoment_BrakingPhase_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalLimbSupportMoment_Braking_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalAnkleSupportMoment_Braking_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalKneeSupportMoment_Braking_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalHipSupportMoment_Braking_AllNegativeSupportMoment = NaN( 1, 1 );
                                    AnkleContribution_BrakingPhase_AllNegativeSupportMoment = NaN( 1, 1 );
                                    KneeContribution_BrakingPhase_AllNegativeSupportMoment = NaN( 1, 1 );
                                    HipContribution_BrakingPhase_AllNegativeSupportMoment = NaN( 1, 1 );



                                    TotalLimbSupportMoment_AllJointsExtensor_BrakingPhase = NaN( 1, 1 );
                                    TotalAnkleSupportMoment_AllJointsExtensor_BrakingPhase = NaN( 1, 1 );
                                    TotalKneeSupportMoment_AllJointsExtensor_BrakingPhase = NaN( 1, 1 );
                                    TotalHipSupportMoment_AllJointsExtensor_BrakingPhase = NaN( 1, 1 );
                                    AnkleContribution_SupportMoment_AllJointsExtensor_Braking = NaN( 1, 1 );
                                    KneeContribution_SupportMoment_AllJointsExtensor_Braking = NaN( 1, 1 );
                                    HipContribution_SupportMoment_AllJointsExtensor_Braking = NaN( 1, 1 );

                                    AnkleContribution_PeakSupportMoment_BrakingPhase = NaN( 1, 1 );
                                    KneeContribution_PeakSupportMoment_BrakingPhase = NaN( 1, 1 );
                                    HipContribution_PeakSupportMoment_BrakingPhase = NaN( 1, 1 );
                                    PeakSupportMoment_BrakingPhase = NaN( 1, 1 );
                                
                                   
                                
                                   PeakSupportPower_BrakingPhase = NaN( 1, 1 );

                                    LimbSupportPower_BrakingPhase_AllNegativeSupportPower = NaN( 1, 1 );
                                    TotalLimbSupportPower_Propulsion_AllPositiveSupportPower = NaN( 1, 1 );
                                    TotalAnkleSupportPower_Propulsion_AllPositiveSupportPower = NaN( 1, 1 );
                                    TotalKneeSupportPower_Propulsion_AllPositiveSupportPower = NaN( 1, 1 );
                                    TotalHipSupportPower_Propulsion_AllPositiveSupportPower = NaN( 1, 1 );
                                    AnkleContribution_BrakingPhase_AllNegativeSupportPower = NaN( 1, 1 );
                                    KneeContribution_BrakingPhase_AllNegativeSupportPower = NaN( 1, 1 );
                                    HipContribution_BrakingPhase_AllNegativeSupportPower = NaN( 1, 1 );


                                    TotalLimbSupportPower_BrakingPhase = NaN( 1, 1 );
                                    TotalAnkleSupportPower_BrakingPhase = NaN( 1, 1 );
                                    TotalKneeSupportPower_BrakingPhase = NaN( 1, 1 );
                                    TotalHipSupportPower_BrakingPhase = NaN( 1, 1 );
                                    AnkleContribution_SupportPower_BrakingPhase = NaN( 1, 1 );
                                    KneeContribution_SupportPower_BrakingPhase = NaN( 1, 1 );
                                    HipContribution_SupportPower_BrakingPhase = NaN( 1, 1 );



                                    TotalLimbSupportMoment_Propulsion_NoFlexorTorque = NaN( 1, 1 );
                                    TotalAnkleSupportMoment_Propulsion_NoFlexorTorque = NaN( 1, 1 );
                                    TotalKneeSupportMoment_Propulsion_NoFlexorTorque = NaN( 1, 1 );
                                    TotalHipSupportMoment_Propulsion_NoFlexorTorque = NaN( 1, 1 );
                                    AnkleSupportMomentContribution_Propulsion_NoFlexorTorque = NaN( 1, 1 );
                                    KneeSupportMomentContribution_Propulsion_NoFlexorTorque = NaN( 1, 1 );
                                    HipSupportMomentContribution_Propulsion_NoFlexorTorque = NaN( 1, 1 );


                                    LimbSupportMoment_PropulsionPhase_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalAnkleSupportMoment_Propulsion_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalKneeSupportMoment_Propulsion_AllNegativeSupportMoment = NaN( 1, 1 );
                                    TotalHipSupportMoment_Propulsion_AllNegativeSupportMoment = NaN( 1, 1 );
                                    AnkleContribution_PropulsionPhase_AllNegativeSupportMoment = NaN( 1, 1 );
                                    KneeContribution_PropulsionPhase_AllNegativeSupportMoment = NaN( 1, 1 );
                                    HipContribution_PropulsionPhase_AllNegativeSupportMoment = NaN( 1, 1 );
                                    
                                    TotalLimbSupportMoment_AllJointsExtensor_PropulsionPhase = NaN( 1, 1 );
                                    TotalAnkleSupportMoment_AllJointsExtensor_PropulsionPhase = NaN( 1, 1 );
                                    TotalKneeSupportMoment_AllJointsExtensor_PropulsionPhase = NaN( 1, 1 );
                                    TotalHipSupportMoment_AllJointsExtensor_PropulsionPhase = NaN( 1, 1 );
                                    AnkleContribution_SupportMoment_AllJointsExtensor_Propulsion = NaN( 1, 1 );
                                    KneeContribution_SupportMoment_AllJointsExtensor_Propulsion = NaN( 1, 1 );
                                    HipContribution_SupportMoment_AllJointsExtensor_Propulsion = NaN( 1, 1 );

                                    AnkleContribution_PeakSupportMoment_PropulsionPhase = NaN( 1, 1 );
                                    KneeContribution_PeakSupportMoment_PropulsionPhase = NaN( 1, 1 );
                                    HipContribution_PeakSupportMoment_PropulsionPhase = NaN( 1, 1 );
                                    PeakSupportMoment_PropulsionPhase = NaN( 1, 1 );
                                
                                   PeakSupportPower_PropulsionPhase = NaN( 1, 1 );

                                    LimbSupportPower_PropulsionPhase_AllPositiveSupportPower = NaN( 1, 1 );
                                    TotalLimbSupportPower_Braking_AllNegativeSupportPower = NaN( 1, 1 );
                                    TotalAnkleSupportPower_Braking_AllNegativeSupportPower = NaN( 1, 1 );
                                    TotalKneeSupportPower_Braking_AllNegativeSupportPower = NaN( 1, 1 );
                                    TotalHipSupportPower_Braking_AllNegativeSupportPower = NaN( 1, 1 );
                                    AnkleContribution_PropulsionPhase_AllPositiveSupportPower = NaN( 1, 1 );
                                    KneeContribution_PropulsionPhase_AllPositiveSupportPower = NaN( 1, 1 );
                                    HipContribution_PropulsionPhase_AllPositiveSupportPower = NaN( 1, 1 );

                                    TotalLimbSupportPower_PropulsionPhase = NaN( 1, 1 );
                                    TotalAnkleSupportPower_PropulsionPhase = NaN( 1, 1 );
                                    TotalKneeSupportPower_PropulsionPhase = NaN( 1, 1 );
                                    TotalHipSupportPower_PropulsionPhase = NaN( 1, 1 );
                                    AnkleContribution_SupportPower_PropulsionPhase = NaN( 1, 1 );
                                    KneeContribution_SupportPower_PropulsionPhase = NaN( 1, 1 );
                                    HipContribution_SupportPower_PropulsionPhase = NaN( 1, 1 );


                                    AnkleSupportPower_EntireBrakingPhase = NaN( 1 );
                                    KneeSupportPower_EntireBrakingPhase = NaN( 1 );
                                    HipSupportPower_EntireBrakingPhase = NaN( 1 );
                                    TotalSupportPower_EntireBrakingPhase = NaN( 1 );
                                    AnkleContribution_SupportPower_EntireBrakingPhase = NaN( 1 );
                                    KneeContribution_SupportPower_EntireBrakingPhase = NaN( 1 );
                                    HipContribution_SupportPower_EntireBrakingPhase = NaN( 1 );
                                    AnkleSupportPower_EntirePropulsionPhase = NaN( 1 );
                                    KneeSupportPower_EntirePropulsionPhase = NaN( 1 );
                                    HipSupportPower_EntirePropulsionPhase = NaN( 1 );
                                    TotalSupportPower_EntirePropulsionPhase = NaN( 1 );
                                    AnkleContribution_SupportPower_EntirePropulsionPhase = NaN( 1 );
                                    KneeContribution_SupportPower_EntirePropulsionPhase = NaN( 1 );
                                    HipContribution_SupportPower_EntirePropulsionPhase = NaN( 1 );


                                    AnkleWorkRatio_PropulsionvsBrakingPhase = NaN( 1);
                                    KneeWorkRatio_PropulsionvsBrakingPhase = NaN( 1);
                                    HipWorkRatio_PropulsionvsBrakingPhase = NaN( 1);

                                    AnkleAverageAbsorptionMEE = NaN( 2, 1);
                                    KneeAverageAbsorptionMEE = NaN( 2, 1);
                                    HipAverageAbsorptionMEE = NaN( 2, 1);
                                    WholeLimbAverageAbsorptionMEE = NaN( 2, 1);
                                    AnkleandKneeAverageAbsorptionMEE = NaN( 2, 1);
                                    AnklePercentAverageMEEAbsorption = NaN( 2, 1);
                                    KneePercentAverageMEEAbsorption = NaN( 2, 1);
                                    HipPercentAverageMEEAbsorption = NaN( 2, 1);

                                    AnkleAverageGenerationMEE = NaN( 2, 1);
                                    KneeAverageGenerationMEE = NaN( 2, 1);
                                    HipAverageGenerationMEE = NaN( 2, 1);
                                    WholeLimbAverageGenerationMEE = NaN( 2, 1);
                                    AnkleandKneeAverageGenerationMEE = NaN( 2, 1);
                                    AnklePercentAverageMEEGeneration = NaN( 2, 1);
                                    KneePercentAverageMEEGeneration = NaN( 2, 1);
                                    HipPercentAverageMEEGeneration = NaN( 2, 1);
                                    AnklePercentAverageMEE_ofAnkleandKneeMEE_Propulsion = NaN( 2, 1);
                                    KneePercentAverageMEE_ofAnkleandKneeMEE_Propulsion = NaN( 2, 1);

                                    AnkleAveragePower_BrakingPhase_GenerationNeutralized = NaN( 2, 1);
                                    KneeAveragePower_BrakingPhase_GenerationNeutralized = NaN( 2, 1);
                                    HipAveragePower_BrakingPhase_GenerationNeutralized = NaN( 2, 1);
                                    LimbAveragePower_BrakingPhase_GenerationNeutralized = NaN( 2, 1);
                                    AnkleContribution_AveragePower_GenerationNeutralized = NaN( 2, 1);
                                    KneeContribution_AveragePower_GenerationNeutralized = NaN( 2, 1);
                                    HipContribution_AveragePower_GenerationNeutralized = NaN( 2, 1);

                                    AnkleAveragePower_PropulsionPhase_AbsorptionNeutralized = NaN( 2, 1);
                                    KneeAveragePower_PropulsionPhase_AbsorptionNeutralized = NaN( 2, 1);
                                    HipAveragePower_PropulsionPhase_AbsorptionNeutralized = NaN( 2, 1);
                                    LimbAveragePower_PropulsionPhase_AbsorptionNeutralized = NaN( 2, 1);
                                    AnkleContribution_AveragePower_AbsorptionNeutralized = NaN( 2, 1);
                                    KneeContribution_AveragePower_AbsorptionNeutralized = NaN( 2, 1);
                                    HipContribution_AveragePower_AbsorptionNeutralized = NaN( 2, 1);


                                    %Initialize variables to hold segmenl angles - entire contact phase
                                        %Foot - Sagittal, then Frontal, then Transverse plane
                                    FootAngleSagittal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    FootAngleFrontal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    FootAngleTransverse_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );

                                        %Shank - Sagittal, then Frontal, then Transverse plane
                                    ShankAngleSagittal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    ShankAngleFrontal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    ShankAngleTransverse_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );

                                        %Thigh - Sagittal, then Frontal, then Transverse plane
                                    ThighAngleSagittal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    ThighAngleFrontal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    ThighAngleTransverse_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );

                                        %Pelvis - Sagittal, then Frontal, then Transverse plane
                                    PelvisAngleSagittal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    PelvisAngleFrontal_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );
                                    PelvisAngleTransverse_IndividualHopsContactPhase= NaN(3, numel(GContactBegin_MoCapFrameNumbers(:,q)) );



                                %Create variables containing the tables for the pth trial
                                HoppingTrialP_OriginalDataTable = getfield(DataWithinMTU_IDforOriginalDataTable_DataStructure,HoppingTrialNumber{q});
                                %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});


%% Extract Joint Data from Data Structure

                                %Pull out the torque data for each joint - pull out from data
                                %structure
                                AnkleSagittalTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Ankle.Sagittal.Torque_ContactPhase,HoppingRate_ID{b});
                                AnkleFrontalTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Ankle.Frontal.Torque_ContactPhase,HoppingRate_ID{b});
                                AnkleTransverseTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Ankle.Transverse.Torque_ContactPhase,HoppingRate_ID{b});
                                KneeSagittalTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Knee.Sagittal.Torque_ContactPhase,HoppingRate_ID{b});
                                KneeFrontalTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Knee.Frontal.Torque_ContactPhase,HoppingRate_ID{b});
                                KneeTransverseTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Knee.Transverse.Torque_ContactPhase,HoppingRate_ID{b});
                                HipSagittalTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Hip.Sagittal.Torque_ContactPhase,HoppingRate_ID{b});
                                HipFrontalTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Hip.Frontal.Torque_ContactPhase,HoppingRate_ID{b});
                                HipTransverseTorqueDataWithinHoppingRateB_DataStructure = getfield(DataWithinMTU_IDforIndividualHops_DataStructure.Hip.Transverse.Torque_ContactPhase,HoppingRate_ID{b});
                                
                                %Pull out the torque data for the Qth hopping bout (10 hops within
                                %each bout)
                                AnkleSagittalTorque_IndividualHops = getfield(AnkleSagittalTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                AnkleFrontalTorque_IndividualHops = getfield(AnkleFrontalTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                AnkleTransverseTorque_IndividualHops = getfield(AnkleTransverseTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                KneeSagittalTorque_IndividualHops = getfield(KneeSagittalTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                KneeFrontalTorque_IndividualHops = getfield(KneeFrontalTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                KneeTransverseTorque_IndividualHops = getfield(KneeTransverseTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                HipSagittalTorque_IndividualHops = getfield(HipSagittalTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                HipFrontalTorque_IndividualHops = getfield(HipFrontalTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});
                                HipTransverseTorque_IndividualHops = getfield(HipTransverseTorqueDataWithinHoppingRateB_DataStructure,HoppingTrialNumber{q});




                             
                                  
%% Extract GContactEnd and GContactBegin                                 

                                  %Extract the frame number corresponding to the beginning of ground
                                  %contact - this was stored in the data structure. The frames we
                                  %are extracting are in the motion capture sampling Hz
                                  GContactBegin_MoCapFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.BeginGroundContact_MoCapFrames;
                                  
                                %Extract the frame number corresponding to the end of ground
                                %contact - this was stored in the data structure. The frames we
                                %are extracting are in the motion capture sampling Hz
                                GContactEnd_forContactPhase_MoCapFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.EndGroundContact_forContactPhase_MoCapFrames;
                                  
                                  
                                  
                                
                                %Extract the frame number corresponding to the end of ground
                                %contact, for calculating hopping height - this was stored in the data structure. The frames we
                                %are extracting are in the motion capture sampling Hz
                                GContactEnd_forHoppingHeight_MoCapFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.EndGroundContact_forHoppingHeight_MoCapFrames;
                                
                                  
                                %Extract the frame number corresponding to the beginning of ground
                                %contact, for calculating hopping height - this was stored in the data structure. The frames we
                                %are extracting are in the motion capture sampling Hz
                                GContactBegin_forHoppingHeight_MoCapFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.BeginGroundContact_forHoppingHeight_MoCapFrames;
                                
                                  
                                %Find the first data point of each hop, for the entire hop
                                %cycle. We classify beginning of hop cycle as first frame of
                                %flight phase. Use tranpose because the vector is currently a row
                                %vector, but our indexing requires a column vector
                                FirstDataPoint_SthHop_MoCapSamplingHz = IndexingDataWithinHoppingRateB_DataStructure.FirstDataPointofSthHop_Truncated_MoCapSamplingHz';





                                 %Extract the frame number corresponding to the beginning of ground
                                  %contact - this was stored in the data structure. The frames we
                                  %are extracting are in the motion capture sampling Hz
                                  GContactBegin_GRFFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.BeginGroundContact_GRFFrames;
                                  
                                %Extract the frame number corresponding to the end of ground
                                %contact - this was stored in the data structure. The frames we
                                %are extracting are in the motion capture sampling Hz
                                GContactEnd_forContactPhase_GRFFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.EndGroundContact_forContactPhase_GRFFrames;
                                  
                                
                                %Extract the frame number corresponding to the end of ground
                                %contact - this was stored in the data structure. The frames we
                                %are extracting are in the motion capture sampling Hz
                                GContactEnd_forFlightPhase_GRFFrameNumbers = IndexingDataWithinHoppingRateB_DataStructure.EndGroundContact_forFlightPhase_GRFFrames;
                                
                                
                                

         %% BEGIN S For Loop for Running Through Each Individual Hop                         
                                %Run loop once for each element within the Qth row of RLimb_GContactBegin_Frames
                                for s = 1 : numel(GContactBegin_MoCapFrameNumbers(:,q))


                                    %Initialize vectors to hold the individual data points from the
                                    %trapezoidal integration below. Will later sum these to obtain the
                                    %total CONTACT phase MEE estimate for each joint
                                    AnkleContactMEE_TempVector = NaN( 7, 1);
                                    KneeContactMEE_TempVector = NaN( 7, 1);
                                    HipContactMEE_TempVector = NaN( 7, 1);
                                    
                                    AnkleContactWork_TempVector = NaN( 7, 1);
                                    KneeContactWork_TempVector = NaN( 7, 1);
                                    HipContactWork_TempVector = NaN( 7, 1);

                                    AnkleContactSagittalTorqueImpulse_TempVector = NaN( 7, 1);
                                    KneeContactSagittalTorqueImpulse_TempVector = NaN( 7, 1);
                                    HipContactSagittalTorqueImpulse_TempVector = NaN( 7, 1);

                                    AnkleContactFrontalTorqueImpulse_TempVector = NaN( 7, 1);
                                    KneeContactFrontalTorqueImpulse_TempVector = NaN( 7, 1);
                                    HipContactFrontalTorqueImpulse_TempVector = NaN( 7, 1);

                                    AnkleContactTransverseTorqueImpulse_TempVector = NaN( 7, 1);
                                    KneeContactTransverseTorqueImpulse_TempVector = NaN( 7, 1);
                                    HipContactTransverseTorqueImpulse_TempVector = NaN( 7, 1);





                                    %Initialize vectors to hold the individual data points from the
                                    %trapezoidal integration below. Will later sum these to obtain the
                                    %total absorption phase MEE estimate for each joint

                                    AnkleWork_Braking_GenerationNeutralized_TempVector = NaN( 7, 1);
                                    KneeWork_Braking_GenerationNeutralized_TempVector = NaN( 7, 1);
                                    HipWork_Braking_GenerationNeutralized_TempVector = NaN( 7, 1);

                                    AnkleAbsorptionMEE_TempVector = NaN( 7, 1);
                                    KneeAbsorptionMEE_TempVector = NaN( 7, 1);
                                    HipAbsorptionMEE_TempVector = NaN( 7, 1);
                                    
                                    AnkleAbsorptionWork_TempVector = NaN( 7, 1);
                                    KneeAbsorptionWork_TempVector = NaN( 7, 1);
                                    HipAbsorptionWork_TempVector = NaN( 7, 1);

                                    AnkleTorqueImpulse_Braking_Sagittal_TempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Braking_Frontal_TempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Braking_Transverse_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Braking_Sagittal_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Braking_Frontal_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Braking_Transverse_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Braking_Sagittal_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Braking_Frontal_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Braking_Transverse_TempVector = NaN( 7, 1);

                                    AnkleTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector = NaN( 7, 1);


                                    %Initialize vectors to hold the individual data points from the
                                    %trapezoidal integration below. Will later sum these to obtain the
                                    %total generation phase MEE estimate for each joint
                                    AnkleGenerationMEE_TempVector = NaN( 7, 1);
                                    KneeGenerationMEE_TempVector = NaN( 7, 1);
                                    HipGenerationMEE_TempVector = NaN( 7, 1);
                                    
                                    AnkleGenerationWork_TempVector = NaN( 7, 1);
                                    KneeGenerationWork_TempVector = NaN( 7, 1);
                                    HipGenerationWork_TempVector = NaN( 7, 1);


                                    AnkleWork_Propulsion_AbsorptionNeutralized_TempVector = NaN( 7, 1);
                                    KneeWork_Propulsion_AbsorptionNeutralized_TempVector = NaN( 7, 1);
                                    HipWork_Propulsion_AbsorptionNeutralized_TempVector = NaN( 7, 1);


                                    AnkleTorqueImpulse_Propulsion_SagittalTempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Propulsion_Frontal_TempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Propulsion_Transverse_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Propulsion_Sagittal_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Propulsion_Frontal_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Propulsion_Transverse_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Propulsion_Sagittal_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Propulsion_Frontal_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Propulsion_Transverse_TempVector = NaN( 7, 1);

                                    AnkleTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    AnkleTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    KneeTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector = NaN( 7, 1);
                                    HipTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector = NaN( 7, 1);


                                    AnkleAverageBrakingTorqueImpulse_Sagittal = NaN( 7, 1);
                                    KneeAverageBrakingTorqueImpulse_Sagittal = NaN( 7, 1);
                                    HipAverageBrakingTorqueImpulse_Sagittal = NaN( 7, 1);

                                    AnkleAveragePropulsionTorqueImpulse_Sagittal = NaN( 7, 1);
                                    KneeAveragePropulsionTorqueImpulse_Sagittal = NaN( 7, 1);
                                    HipAveragePropulsionTorqueImpulse_Sagittal = NaN( 7, 1);


                                    AnkleAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    AnkleAverageBrakingTorqueImpulse_Frontal_NoFlexTorq = NaN( 7, 1);
                                    AnkleAverageBrakingTorqueImpulse_Transverse_NoFlexTorq = NaN( 7, 1);
                                    KneeAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    KneeAverageBrakingTorqueImpulse_Frontal_NoFlexTorq = NaN( 7, 1);
                                    KneeAverageBrakingTorqueImpulse_Transverse_NoFlexTorq = NaN( 7, 1);
                                    HipAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    HipAverageBrakingTorqueImpulse_Frontal_NoFlexTorq = NaN( 7, 1);
                                    HipAverageBrakingTorqueImpulse_Transverse_NoFlexTorq = NaN( 7, 1);

                                    AnkleAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    AnkleAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq = NaN( 7, 1);
                                    AnkleAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq = NaN( 7, 1);
                                    KneeAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    KneeAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq = NaN( 7, 1);
                                    KneeAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq = NaN( 7, 1);
                                    HipAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    HipAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq = NaN( 7, 1);
                                    HipAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq = NaN( 7, 1);

                                    
                                    TotalLimbAverageTorqueImpulse_Braking_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    TotalLimbAverageTorqueImpulse_Braking_Frontal_NoFlexTorq = NaN( 7, 1);
                                    TotalLimbAverageTorqueImpulse_Braking_Transverse_NoFlexTorq = NaN( 7, 1);

                                    TotalLimbAverageTorqueImpulse_Propulsion_Sagittal_NoFlexTorq = NaN( 7, 1);
                                    TotalLimbAverageTorqueImpulse_Propulsion_Frontal_NoFlexTorq = NaN( 7, 1);
                                    TotalLimbAverageTorqueImpulse_Propulsion_Transverse_NoFlexTorq = NaN( 7, 1);

                                    AnkleContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq = NaN( 7, 1);
                                    AnkleContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq = NaN( 7, 1);
                                    AnkleContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq = NaN( 7, 1);
                                    KneeContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq = NaN( 7, 1);
                                    KneeContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq = NaN( 7, 1);
                                    KneeContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq = NaN( 7, 1);
                                    HipContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq = NaN( 7, 1);
                                    HipContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq = NaN( 7, 1);
                                    HipContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq = NaN( 7, 1);

                                    AnkleContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    AnkleContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    AnkleContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    KneeContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    KneeContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    KneeContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    HipContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    HipContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq = NaN( 7, 1);
                                    HipContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq = NaN( 7, 1);
                                                                        

                                    %Find the shortest duration of the flight phase, among all hops
                                    MinLengthofFlightPhase_MoCapSamplingHz(s,q) = min( IndexingDataWithinHoppingRateB_DataStructure.LengthofFlightPhase_NonTruncated_MoCapSamplingHz, [], 'omitnan' );
                                    
                                    %Find the duration of the flight phase for hop s
                                    LengthofFlightPhase_MoCapSamplingHz( s ) = IndexingDataWithinHoppingRateB_DataStructure.LengthofFlightPhase_NonTruncated_MoCapSamplingHz( s );
                                    
                                    

                                    
                                    

                                    %Create a vector containing all Frames for the Sth hop, from the
                                    %beginning of one flight phase and the beginning of the next. Subtract
                                    %one from the GContactEnd frame number since the frame number is the
                                    %first frame of flight phase. Want to end at the last frame of contact
                                    %phase
                                    AllFrames_SthHop_MoCap = FirstDataPoint_SthHop_MoCapSamplingHz(s,q):(GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);

                                    %The last data point of each hop is the last frame of the ground
                                    %contact phase. Subtract 1 from GContactEnd since GContactEnd is
                                    %actually the first frame of the flight phase
                                    LastDataPoint_SthHop_MoCapSamplingHz(s,q) = (GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);
                                    

                                    %Find the number of elements of the Sth hop.
                                    NumEl_SthHop_MoCap(s) = numel(AllFrames_SthHop_MoCap);



                                    %Find the length of the contact phase in frames
                                    LengthofContactPhase_Frames_GRFSampHz( s ) = numel( GContactBegin_GRFFrameNumbers(s,q) : (GContactEnd_forContactPhase_GRFFrameNumbers(s,q)-1) );

                                    %Find the length of the contact phase in seconds
                                    LengthofContactPhase_Seconds( s ) = LengthofContactPhase_Frames_GRFSampHz( s ) ./ GRFSampHz;


                                    %Length of entire hop
                                    LengthofHopCycle_sec( s ) = numel( GContactEnd_forFlightPhase_GRFFrameNumbers( s ) : (GContactEnd_forContactPhase_GRFFrameNumbers(s,q)-1) ) ./ GRFSampHz;

                                    %Hop Frequency
                                    HopFrequency( s ) = 1/LengthofHopCycle_sec( s ) ;





                                    %We'll start pulling out variables from the Visual 3D tables.
                                    %The joints are labeled LAnkle or Rankle - will need to use an
                                    %If statement to make sure we pull out the correct limb
                                     if strcmp( LimbID_forV3DOutput{a}, 'LeftLimb')


                                        %Split Ankle Angular Position, Torque, Power into Individual Hops                            
                                        AnklePowerSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_PowerScalar(AllFrames_SthHop_MoCap);


                                        %Split Knee Angular Position, Torque, Power into Individual Hops
                                        KneePowerSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_PowerScalar(AllFrames_SthHop_MoCap);



                                        %Split Hip Angular Position, Torque, Power into Individual Hops
                                        HipPowerSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_PowerScalar(AllFrames_SthHop_MoCap);


                                        %Split the CoM vertical position data into individual hops
                                        
                                        %Cannot compute CoM position for HP02 - hopping was
                                        %collected with US, so one shank doesn't have markers
                                        if ~strcmp( ParticipantList{ n }, 'HP02' )
                                            
                                            CoMVerticalPosition_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                                HoppingTrialP_OriginalDataTable.CoM_Position_2(AllFrames_SthHop_MoCap);
                                        
                                        end
                                        
                                        %Split the L5-S1 vertical position data into individual hops
                                         L5S1VerticalPosition_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.L5S1_2(AllFrames_SthHop_MoCap);

                                        %%Create variables containing the kinematics and kinetics for ground
                                        %%contact phase ONLY
                                        AllFrames_SthHopContactPhase_MoCap = GContactBegin_MoCapFrameNumbers(s,q):(GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);

                                        %Find the number of elements of the Sth hop contact phase.
                                        NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) = numel(AllFrames_SthHopContactPhase_MoCap);

                                        %Splice out the joint angle data for the contact phase of the Sth hop by using the Frames for the Sth hop
                                            %Sagittal Plane
                                        KneeAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LKnee_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        AnkleAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LAnkle_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        HipAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LHip_Angle(AllFrames_SthHopContactPhase_MoCap);
                                            %Frontal Plane
                                        KneeAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LKnee_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        AnkleAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LAnkle_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        HipAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LHip_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                            %Transverse Plane
                                        KneeAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LKnee_Angle_2(AllFrames_SthHopContactPhase_MoCap);
                                        AnkleAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LAnkle_Angle_2(AllFrames_SthHopContactPhase_MoCap);
                                        HipAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LHip_Angle_2(AllFrames_SthHopContactPhase_MoCap);

                                        
                                        


        %% Split Ankle Power into the contact phase of individual Hops

                                        AnklePowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_PowerScalar(AllFrames_SthHopContactPhase_MoCap);


        %% Split Knee  Power into the contact phase of Individual Hops


                                        KneePowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_PowerScalar(AllFrames_SthHopContactPhase_MoCap);

        %% Split Hip Power into the contact phase of Individual Hops


                                        HipPowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_PowerScalar(AllFrames_SthHopContactPhase_MoCap);

                                        
      %% Split CoM Position into the contact phase of Individual Hops                                  
                                        
                                        %Cannot compute CoM position for HP02 - hopping was
                                        %collected with US, so one shank doesn't have markers
                                        if ~strcmp( ParticipantList{ n }, 'HP02' )
                                            
                                            CoMVerticalPosition_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.CoM_Position_2(AllFrames_SthHopContactPhase_MoCap);
                                        
                                        end
                                        


                                        
      %% Split Joint Angular Velocity (not for energy transfer) into the contact phase of Individual Hops
      
                                        AnkleAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_AngVel(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_AngVel(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_AngVel(AllFrames_SthHopContactPhase_MoCap);                                       
      


                                        AnkleAngVelFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_AngVel_1(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngVelFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_AngVel_1(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngVelFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_AngVel_1(AllFrames_SthHopContactPhase_MoCap);                                          
      



                                        AnkleAngVelTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LAnkle_AngVel_2(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngVelTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LKnee_AngVel_2(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngVelTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LHip_AngVel_2(AllFrames_SthHopContactPhase_MoCap);            
      



%% Split Segment Angular Velocity into contact phase of individual hops

                                        FootAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LFoot_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);      

                                        ShankAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LShank_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        ThighAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.LThigh_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);     
%                                         
%                                         PelvisAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
%                                             HoppingTrialP_OriginalDataTable.Pelvis_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);     


%% Split Segment Angles into the contact phase of Individual Hops
                                        
                                           
                                        %Splice out the segment angle data for the contact phase of the Sth hop by using the Frames for the Sth hop
                                            %Foot - Sagittal, then Frontal, then Transverse plane
                                        FootAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LFoot_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        FootAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LFoot_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        FootAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LFoot_Angle_2(AllFrames_SthHopContactPhase_MoCap);

                                            %Shank - Sagittal, then Frontal, then Transverse plane
                                        ShankAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LShank_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        ShankAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LShank_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        ShankAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LShank_Angle_2(AllFrames_SthHopContactPhase_MoCap);

                                            %Thigh - Sagittal, then Frontal, then Transverse plane
                                        ThighAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LThigh_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        ThighAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LThigh_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        ThighAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.LThigh_Angle_2(AllFrames_SthHopContactPhase_MoCap);

                                            %Pelvis - Sagittal, then Frontal, then Transverse plane
                                        PelvisAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.Pelvis_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        PelvisAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.Pelvis_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        PelvisAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.Pelvis_Angle_2(AllFrames_SthHopContactPhase_MoCap);
          


                                        
                                        
      %% Split Joint Torque (not for energy transfer) into the contact phase of Individual Hops
                                        AnkleTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LAnkle_Torque(AllFrames_SthHopContactPhase_MoCap);  
        
                                        AnkleTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LAnkle_Torque_1(AllFrames_SthHopContactPhase_MoCap);  
        
                                        AnkleTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LAnkle_Torque_2(AllFrames_SthHopContactPhase_MoCap);  
                                                
        
        
        
        
                                        KneeTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LKnee_Torque(AllFrames_SthHopContactPhase_MoCap);               
        
                                        KneeTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LKnee_Torque_1(AllFrames_SthHopContactPhase_MoCap); 
        
                                        KneeTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LKnee_Torque_2(AllFrames_SthHopContactPhase_MoCap);                   
                                                
        
        
        
                                        HipTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LHip_Torque(AllFrames_SthHopContactPhase_MoCap); 
        
                                        HipTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LHip_Torque_1(AllFrames_SthHopContactPhase_MoCap); 
        
                                        HipTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.LHip_Torque_2(AllFrames_SthHopContactPhase_MoCap); 
                                                
                                        

                                     elseif strcmp( LimbID_forV3DOutput{a},'RightLimb')


                                        %Split Ankle Angular Position, Torque, Power into Individual Hops                            
                                        AnklePowerSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_PowerScalar(AllFrames_SthHop_MoCap);


                                        %Split Knee Angular Position, Torque, Power into Individual Hops
                                        KneePowerSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_PowerScalar(AllFrames_SthHop_MoCap);



                                        %Split Hip Angular Position, Torque, Power into Individual Hops
                                        HipPowerSagittal_IndividualHops(1:NumEl_SthHop_MoCap(s),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_PowerScalar(AllFrames_SthHop_MoCap);




                                        %%Create variables containing the kinematics and kinetics for ground
                                        %%contact phase ONLY
                                        AllFrames_SthHopContactPhase_MoCap = GContactBegin_MoCapFrameNumbers(s,q):(GContactEnd_forContactPhase_MoCapFrameNumbers(s,q)-1);

                                        %Find the number of elements of the Sth hop contact phase.
                                        NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) = numel(AllFrames_SthHopContactPhase_MoCap);



                                        
                                        
                                        

        %% Split Ankle Power into the contact phase of individual Hops

                                        AnklePowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_PowerScalar(AllFrames_SthHopContactPhase_MoCap);


        %% Split Knee  Power into the contact phase of Individual Hops


                                        KneePowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_PowerScalar(AllFrames_SthHopContactPhase_MoCap);

        %% Split Hip Power into the contact phase of Individual Hops


                                        HipPowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_PowerScalar(AllFrames_SthHopContactPhase_MoCap);
                                        
                                        
      %% Split CoM Position into the contact phase of Individual Hops                       
      
                                        %Cannot compute CoM position for HP02 - hopping was
                                        %collected with US, so one shank doesn't have markers
                                        if ~strcmp( ParticipantList{ n }, 'HP02' )
                                            
                                            CoMVerticalPosition_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                HoppingTrialP_OriginalDataTable.CoM_Position_2(AllFrames_SthHopContactPhase_MoCap);        
                                            
                                        end
  


      %% Split Joint Angular Position into the contact phase of Individual Hops
      
                                        AnkleAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle(AllFrames_SthHopContactPhase_MoCap);     



                        
                                        AnkleAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle_1(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle_1(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle_1(AllFrames_SthHopContactPhase_MoCap);     






                                        AnkleAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_Angle_2(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_Angle_2(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_Angle_2(AllFrames_SthHopContactPhase_MoCap);                
                                        
                                        

                                        
                                        
                                        ShankAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RShank_Angle(AllFrames_SthHopContactPhase_MoCap);

                                        ThighAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RThigh_Angle(AllFrames_SthHopContactPhase_MoCap);

                                        PelvisAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.Pelvis_Angle(AllFrames_SthHopContactPhase_MoCap);           






      %% Split Joint Angular Velocity into the contact phase of Individual Hops                                        

                                        AnkleAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_AngVel(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_AngVel(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_AngVel(AllFrames_SthHopContactPhase_MoCap);     
      



                                        AnkleAngVelFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_AngVel_1(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngVelFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_AngVel_1(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngVelFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_AngVel_1(AllFrames_SthHopContactPhase_MoCap);     
      



                                        AnkleAngVelTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RAnkle_AngVel_2(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        KneeAngVelTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RKnee_AngVel_2(AllFrames_SthHopContactPhase_MoCap);     
                                        
                                        HipAngVelTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RHip_AngVel_2(AllFrames_SthHopContactPhase_MoCap);         


%% Split Segment Angular Velocity into contact phase of individual hops

                                        FootAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RFoot_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);      

                                        ShankAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RShank_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);      
                                        
                                        ThighAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                            HoppingTrialP_OriginalDataTable.RThigh_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);     
%                                         
%                                         PelvisAngVelSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
%                                             HoppingTrialP_OriginalDataTable.Pelvis_AngularVelocity(AllFrames_SthHopContactPhase_MoCap);     
                                        


%% Split Segment Angles into the contact phase of Individual Hops
                                        
                                           
                                        %Splice out the segment angle data for the contact phase of the Sth hop by using the Frames for the Sth hop
                                            %Foot - Sagittal, then Frontal, then Transverse plane
                                        FootAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RFoot_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        FootAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RFoot_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        FootAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RFoot_Angle_2(AllFrames_SthHopContactPhase_MoCap);

                                            %Shank - Sagittal, then Frontal, then Transverse plane
                                        ShankAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RShank_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        ShankAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RShank_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        ShankAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RShank_Angle_2(AllFrames_SthHopContactPhase_MoCap);

                                            %Thigh - Sagittal, then Frontal, then Transverse plane
                                        ThighAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RThigh_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        ThighAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RThigh_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        ThighAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.RThigh_Angle_2(AllFrames_SthHopContactPhase_MoCap);

                                            %Pelvis - Sagittal, then Frontal, then Transverse plane
                                        PelvisAngleSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.Pelvis_Angle(AllFrames_SthHopContactPhase_MoCap);
                                        PelvisAngleFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.Pelvis_Angle_1(AllFrames_SthHopContactPhase_MoCap);
                                        PelvisAngleTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) = HoppingTrialP_OriginalDataTable.Pelvis_Angle_2(AllFrames_SthHopContactPhase_MoCap);
          


                                        
       %% Split Joint Torque into the contact phase of Individual Hops
                                        AnkleTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RAnkle_Torque(AllFrames_SthHopContactPhase_MoCap); 
        
                                        AnkleTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RAnkle_Torque_1(AllFrames_SthHopContactPhase_MoCap); 
        
                                        AnkleTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RAnkle_Torque_2(AllFrames_SthHopContactPhase_MoCap);
                                                
        
        
        
                                        KneeTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RKnee_Torque(AllFrames_SthHopContactPhase_MoCap);         
        
                                        KneeTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RKnee_Torque_1(AllFrames_SthHopContactPhase_MoCap); 
        
                                        KneeTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RKnee_Torque_2(AllFrames_SthHopContactPhase_MoCap);                          
                                                
        
        
        
                                        HipTorqueSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RHip_Torque(AllFrames_SthHopContactPhase_MoCap);       
        
                                        HipTorqueFrontal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RHip_Torque_1(AllFrames_SthHopContactPhase_MoCap); 
        
                                        HipTorqueTransverse_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                    HoppingTrialP_OriginalDataTable.RHip_Torque_2(AllFrames_SthHopContactPhase_MoCap);                                 
                                        
                                        

                                     end %End If Loop



%% Split L5-S1 vertical position into contact phase of Individual Hops

                                         %L5-S1 vertical position
                                            %ATx25 is missing L5-S1 marker for Involved Limb, 2.3 Hz. Use LPSIS
                                            %instead
                                        if strcmp( ParticipantList{ n }, 'ATx25' ) && strcmp( LimbID{a}, 'InvolvedLimb' ) && strcmp( HoppingRate_ID{ b }, 'TwoPoint3Hz' )
                                            
                                             L5S1VerticalPosition_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                HoppingTrialP_OriginalDataTable.LPSIS_2(AllFrames_SthHopContactPhase_MoCap);

                                        else

                                            L5S1VerticalPosition_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) =...
                                                HoppingTrialP_OriginalDataTable.L5S1_2(AllFrames_SthHopContactPhase_MoCap);

                                        end

                                     
        %% Plot Ankle Power Contact Phase Hops

                                    if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )
            
                                        if s == numel(GContactBegin_MoCapFrameNumbers(:,q))

                                            %Create a time vector for the entire hop cycle, for plotting
                                            TimeVector_Power = (1:size(AnklePowerSagittal_IndividualHops,1))./MoCapSampHz;
    
                                            %Create a time vector for the entire contact phase, for plotting
                                            TimeVector_Power_ContactPhase = (1:size(AnklePowerSagittal_IndividualHopsContactPhase,1))./MoCapSampHz;
    
                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Ankle  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )
    
                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Check Splitting of Ankle','FontSize',18)
    
                                            %Set data for the first subplot
                                            subplot(2,1,1)
                                            plot(TimeVector_Power,AnklePowerSagittal_IndividualHops,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line([0  max(TimeVector_Power)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Power','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, 12] ) 
                                            legend('Location','bestoutside')
    
                                            %Set data for the second subplot
                                            subplot(2,1,2)
                                            plot(TimeVector_Power_ContactPhase,AnklePowerSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line([0  max(TimeVector_Power_ContactPhase)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Power, Contact Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, 12] ) 
                                            legend('Location','bestoutside')
    
                                            %If s is the same as the number of hops, %pause the code so we
                                            %can view the plot before the next plot is made
                                            if s == numel(GContactBegin_MoCapFrameNumbers(:,q))
    
                                                %pause

                                                savefig( [ ParticipantList{n}, '_', 'AnklePower', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );
    
                                            end
    
    
    
                %% Plot Knee Power Contact Phase Hops
    
                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Knee  ' '  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )
    
                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Check Splitting of Knee','FontSize',18)
    
                                            %Set data for the first subplot
                                            subplot(2,1,1)
                                            plot(TimeVector_Power,KneePowerSagittal_IndividualHops,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line([0  max(TimeVector_Power)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Power','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, 12] ) 
                                            legend('Location','bestoutside')
    
                                            %Set data for the second subplot
                                            subplot(2,1,2)
                                            plot(TimeVector_Power_ContactPhase,KneePowerSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line([0  max(TimeVector_Power_ContactPhase)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Power, Contact Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, 12] ) 
                                            legend('Location','bestoutside')
    
                                            %If s is the same as the number of hops, %pause the code so we
                                            %can view the plot before the next plot is made
                                            if s == numel(GContactBegin_MoCapFrameNumbers(:,q))
    
                                                %pause

                                                savefig( [ ParticipantList{n}, '_', 'KneePower', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );
    
                                            end
    
    
                %% Plot Hip Power Contact Phase Hops
    
                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Hip  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )
    
                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Check Splitting of Hip')
    
                                            %Set data for the first subplot
                                            subplot(2,1,1)
                                            plot(TimeVector_Power,HipPowerSagittal_IndividualHops,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line([0  max(TimeVector_Power)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Power','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, 12] ) 
                                            legend('Location','bestoutside')
    
                                            %Set data for the second subplot
                                            subplot(2,1,2)
                                            plot(TimeVector_Power_ContactPhase,HipPowerSagittal_IndividualHopsContactPhase,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line([0  max(TimeVector_Power_ContactPhase)],[0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Power, Contact Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, 12] ) 
                                            legend('Location','bestoutside')
    

                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'HipPower', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all


                                        end
                                    
                                        
                                    end





%% Find Minimum L5-S1 Vertical Position


                                    %There may be multiple frames where L5-S1 marker is at its lowest
                                    %vertical position. If so, take the median and use this to define the
                                    %end of braking phase and beginning of propulsion phase. 
                                    FrameofMinL5S1Position_Median = median( find( L5S1VerticalPosition_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s) == min( L5S1VerticalPosition_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) , s ), [],  'omitnan'  )  ),  'omitnan' );

                                    %If median is not an integer, take the frame on either side as the end of braking
                                    %phase and beginning of propulsion
                                    if ceil( FrameofMinL5S1Position_Median ) == FrameofMinL5S1Position_Median

                                      %Find the frame corresponding to the lowest position of the CoM. There
                                      %may be multiple frames - if so, take the first one as the end of
                                      %braking phase
                                      FrameofMinL5S1Position_EndBraking(s) = FrameofMinL5S1Position_Median;

                                      %Find the frame corresponding to the lowest position of the CoM. osition of the CoM. There
                                      %may be multiple frames - if so, take the last one as the end of
                                      %braking phase
                                      FrameofMinL5S1Position_BeginPropulsion(s) = FrameofMinL5S1Position_Median+1;

                                    else

                                        %Find the frame corresponding to the lowest position of the CoM. There
                                      %may be multiple frames - if so, take the first one as the end of
                                      %braking phase
                                      FrameofMinL5S1Position_EndBraking(s) = floor( FrameofMinL5S1Position_Median );

                                      %Find the frame corresponding to the lowest position of the CoM. osition of the CoM. There
                                      %may be multiple frames - if so, take the last one as the end of
                                      %braking phase
                                      FrameofMinL5S1Position_BeginPropulsion(s) = ceil( FrameofMinL5S1Position_Median );

                                    end




%% Split Joint Power and Angular Velocity into Absorption and Generation Phases Based on L5S1 Position



                                     %Find the length of the absorption and generation phases.
                                     %Absorption phase is from beginning of ground contact to frame
                                     %of lowest position of CoM. Generation phase is from frame of
                                     %lowest position of CoM to end of ground contact
                                    LengthofBrakingPhase(s) = numel( 1 : FrameofMinL5S1Position_EndBraking(s) );
                                    LengthofPropulsionPhase(s) = numel( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) );

                                        
                                    %Find length of braking and propulsion phase in seconds
                                    LengthofBrakingPhase_Seconds(s) = LengthofBrakingPhase(s) ./ MoCapSampHz;
                                    LengthofPropulsionPhase_Seconds(s) = LengthofPropulsionPhase(s) ./ MoCapSampHz;
                                    
                                    %Split ankle, knee, and hip power data into absorption phases
                                    
                                        %Power
                                   AnklePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnklePowerSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneePowerSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipPower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipPowerSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  
                                  %Angular velocity
                                   AnkleSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleAngleSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeAngleSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipAngleSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );

                                          %Angular velocity
                                   AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleAngVelSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeAngVelSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipAngVelSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  
                                        %Torque
                                    AnkleSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleTorqueSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeTorqueSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipTorqueSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );        




                                          %Angular velocity
                                   AnkleFrontalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleAngVelFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeFrontalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeAngVelFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipFrontalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipAngVelFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );

                                  %Angular velocity
                                   AnkleFrontalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleAngleFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeFrontalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeAngleFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipFrontalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipAngleFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  
                                        %Torque
                                    AnkleFrontalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleTorqueFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeFrontalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeTorqueFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipFrontalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipTorqueFrontal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );                                       
                                  
                                  


                                  
                                          %Angular velocity
                                   AnkleTransverseAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleAngleTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeTransverseAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeAngleTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipTransverseAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipAngleTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );

                                  %Angular velocity
                                   AnkleTransverseAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleAngVelTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeTransverseAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeAngVelTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipTransverseAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipAngVelTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  
                                        %Torque
                                    AnkleTransverseTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  AnkleTorqueTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  KneeTransverseTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  KneeTorqueTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  HipTransverseTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  HipTorqueTransverse_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );                                       
                                  
                                  


                                  
                                  %Angular velocity
                                   ShankSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  ShankAngleSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  ThighSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  ThighAngleSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  PelvisSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  PelvisAngleSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );

                                          %Angular velocity
                                   ShankSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  ShankAngVelSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                  ThighSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) =  ThighAngVelSagittal_IndividualHopsContactPhase( 1 : FrameofMinL5S1Position_EndBraking(s), s );
                                       
                                  
                                  
                                  
                                  %Split ankle, knee, and hip data into generation phases
                                  
                                        %Power
                                  AnklePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnklePowerSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneePowerSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipPower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipPowerSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  

    
                                         %Angular velocity
                                  AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleAngleSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeAngleSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipAngleSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  

                                         %Angular velocity
                                  AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleAngVelSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeAngVelSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipAngVelSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  
                                  
                                        %Torque
                                  AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleTorqueSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeTorqueSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipTorqueSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  

    


                                         %Angular velocity
                                  AnkleFrontalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleAngleFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeFrontalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeAngleFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipFrontalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipAngleFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  
                                         %Angular velocity
                                  AnkleFrontalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleAngVelFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeFrontalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeAngVelFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipFrontalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipAngVelFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  
                                  
                                        %Torque
                                  AnkleFrontalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleTorqueFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeFrontalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeTorqueFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipFrontalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipTorqueFrontal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  

    
                                    %Angular leocity
                                  AnkleTransverseAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleAngleTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeTransverseAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeAngleTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipTransverseAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipAngleTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  

                                         %Angular velocity
                                  AnkleTransverseAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleAngVelTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeTransverseAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeAngVelTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipTransverseAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipAngVelTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  
                                  
                                        %Torque
                                  AnkleTransverseTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  AnkleTorqueTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  KneeTransverseTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  KneeTorqueTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  HipTransverseTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  HipTorqueTransverse_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );                                     
                                  
                                  


                                  
                                  %Angles
                                   ShankSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  ShankAngleSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  ThighSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  ThighAngleSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  PelvisSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  PelvisAngleSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );

                                          %Angular velocity
                                   ShankSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  ShankAngVelSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  ThighSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) =  ThighAngVelSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s );
                                  
                                  

%% Calculate Joint Range of Motion During Braking and Absorption Phases

                                AnkleSagittalRoM_BrakingPhase( s ) = max( AnkleSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ), [],  'omitnan' ) - min( AnkleSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ),  [], 'omitnan' );
                                KneeSagittalRoM_BrakingPhase( s ) = max( KneeSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ), [], 'omitnan' ) - min( KneeSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ),  [], 'omitnan' );
                                HipSagittalRoM_BrakingPhase( s ) = max( HipSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ),  [], 'omitnan' ) - min( HipSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ),  [], 'omitnan' );

                                AnkleSagittalRoM_PropulsionPhase( s ) = min( AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ), [], 'omitnan' ) - max( AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ),  [], 'omitnan' );
                                KneeSagittalRoM_PropulsionPhase( s ) = min( KneeSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ), [], 'omitnan' ) - max( KneeSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ),  [], 'omitnan' ) ;
                                HipSagittalRoM_PropulsionPhase( s ) = min( HipSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ), [], 'omitnan' ) - max( HipSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ),  [], 'omitnan' );



%% Find Time to Peak Joint Angular Position and Angular Velocity

                                TimetoPeakDF_BrakingPhase( s ) = find( AnkleSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) == max( AnkleSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ), [],  'omitnan' ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakKneeFlex_BrakingPhase( s ) = find( KneeSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) == max( KneeSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ),  [], 'omitnan' ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakHipFlex_BrakingPhase( s ) = find( HipSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) == max( HipSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ),  [], 'omitnan' ), 1, 'First' ) ./ MoCapSampHz;
                                  
                                TimetoPeakPF_PropulsionPhase( s ) = find( AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) == min( AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ),  [], 'omitnan' ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakKneeExt_PropulsionPhase( s ) = find( KneeSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) == min( KneeSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ),  [], 'omitnan' ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakHipExt_PropulsionPhase( s ) = find( HipSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) == min( HipSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ),  [], 'omitnan' ), 1, 'First' ) ./ MoCapSampHz;
                                  
                                AnkleInitialContactAngle( s ) = AnkleSagittalAngle_BrakingPhase_L5S1AsReference( 1, s );
                                KneeInitialContactAngle( s ) = KneeSagittalAngle_BrakingPhase_L5S1AsReference( 1, s );
                                HipInitialContactAngle( s ) = HipSagittalAngle_BrakingPhase_L5S1AsReference( 1, s );

                                AnkleInitialPropulsionPhaseAngle( s ) = AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( 1, s );
                                KneeInitialPropulsionPhaseAngle( s ) = KneeSagittalAngle_PropulsionPhase_L5S1AsReference( 1, s );
                                HipInitialPropulsionPhaseAngle( s ) = HipSagittalAngle_PropulsionPhase_L5S1AsReference( 1, s );

                                PeakDF_BrakingPhase( s ) = max( AnkleSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) );
                                PeakKneeFlex_BrakingPhase( s ) = max( KneeSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) );
                                PeakHipFlex_BrakingPhase( s ) = max( HipSagittalAngle_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) );


                                PeakPF_PropulsionPhase( s ) = min( AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) );
                                PeakKneeExt_PropulsionPhase( s ) = min( KneeSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) );
                                PeakHipExt_PropulsionPhase( s ) = min( HipSagittalAngle_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) );


                                TimetoPeakDFAngVel_BrakingPhase( s ) = find( AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) == max( AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakKneeFlexAngVel_BrakingPhase( s ) = find( KneeSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) == max( KneeSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakHipFlexAngVel_BrakingPhase( s ) = find( HipSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) == max( HipSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ), 1, 'First' ) ./ MoCapSampHz;
                                  
                                TimetoPeakPFAngVel_PropulsionPhase( s ) = find( AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) == min( AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakKneeExtAngVel_PropulsionPhase( s ) = find( KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) == min( KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ), 1, 'First' ) ./ MoCapSampHz;
                                TimetoPeakHipExtAngVel_PropulsionPhase( s ) = find( HipSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) == min( HipSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ), 1, 'First' ) ./ MoCapSampHz;
                                  

                                AnkleAngleAtPeakAngVel_BrakingPhase( s ) = AnkleSagittalAngle_BrakingPhase_L5S1AsReference( find( AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ==...
                                    max( AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ), 1, 'First' ), s );
                                KneeAngleAtPeakAngVel_BrakingPhase( s ) = KneeSagittalAngle_BrakingPhase_L5S1AsReference( find( KneeSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ==...
                                    max( KneeSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ), 1, 'First' ), s );
                                HipAngleAtPeakAngVel_BrakingPhase( s ) = HipSagittalAngle_BrakingPhase_L5S1AsReference( find( HipSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ==...
                                    max( HipSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ) ), 1, 'First' ), s );



                                AnkleAngleAtPeakAngVel_PropulsionPhase( s ) = AnkleSagittalAngle_PropulsionPhase_L5S1AsReference( find( AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ==...
                                    max( AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ), 1, 'First' ), s );
                                KneeAngleAtPeakAngVel_PropulsionPhase( s ) = KneeSagittalAngle_PropulsionPhase_L5S1AsReference( find( KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ==...
                                    max( KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ), 1, 'First' ), s );
                                HipAngleAtPeakAngVel_PropulsionPhase( s ) = HipSagittalAngle_PropulsionPhase_L5S1AsReference( find( HipSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ==...
                                    max( HipSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ) ), 1, 'First' ), s );



%% Plot Joint Power - Split into Absorption and Generation Phases

                                     if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )

                                        %If s is the same as the number of hops, create plots to check whether joint power seems to be correctly split into absorption and generation phases.
                                        %%pause the code so we
                                        %can view the plot before the next plot is made. Then,
                                        %close all open plots
                                        if s == numel(GContactBegin_MoCapFrameNumbers(:,q))

                                            TimeVector_PowerAbsorption = ( 1 : max( LengthofBrakingPhase ) ) ./ MoCapSampHz;
                                            TimeVector_PowerGeneration = ( 1 : max( LengthofPropulsionPhase ) ) ./ MoCapSampHz;

                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Joint Power into Braking and Propulsion Phases' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )

                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Check Splitting of Joint Power into Braking and Propulsion Phases')

                                            %Set data for the first subplot - ankle power, absorption
                                            %phase
                                            subplot(3,2,1)
                                            plot(TimeVector_PowerAbsorption, AnklePower_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Power - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, max( max( HipPower_BrakingPhase_L5S1AsReference ) ) ] ) 
                                            legend('Location','bestoutside')

                                            %Set data for the second subplot - ankle power, generation
                                            %phase
                                            subplot(3,2,2)
                                            plot(TimeVector_PowerGeneration, AnklePower_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Power - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [ min( min( HipPower_BrakingPhase_L5S1AsReference ) ), 12] ) 
                                            legend('Location','bestoutside')







                                            %Set data for the 3rd subplot - knee power, absorption
                                            %phase
                                            subplot(3,2,3)
                                            plot(TimeVector_PowerAbsorption, KneePower_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Power - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, max( max( HipPower_BrakingPhase_L5S1AsReference ) )] ) 
                                            legend('Location','bestoutside')

                                            %Set data for the 4th subplot - knee power, generation
                                            %phase
                                            subplot(3,2,4)
                                            plot(TimeVector_PowerGeneration, KneePower_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Power - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [ min( min( HipPower_BrakingPhase_L5S1AsReference ) ), 12] ) 
                                            legend('Location','bestoutside')







                                            %Set data for the 5th subplot - hip power, absorption
                                            %phase
                                            subplot(3,2,5)
                                            plot(TimeVector_PowerAbsorption, HipPower_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Power - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [-12, max( max( HipPower_BrakingPhase_L5S1AsReference ) )] ) 
                                            legend('Location','bestoutside')

                                            %Set data for the 6th subplot - hip power, generation
                                            %phase
                                            subplot(3,2,6)
                                            plot(TimeVector_PowerGeneration, HipPower_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Power - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Power (W/kg) [ - = Absorption, + = Generation ]','FontSize',14)
                                            ylim( [ min( min( HipPower_BrakingPhase_L5S1AsReference ) ), 12] ) 
                                            legend('Location','bestoutside')




                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'PowerPhases', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all

                                        end                                





     %% Plot Joint Torque - Split into Absorption and Generation Phases

                                        %If s is the same as the number of hops, create plots to check whether joint torque seems to be correctly split into absorption and generation phases.
                                        %%pause the code so we
                                        %can view the plot before the next plot is made. Then,
                                        %close all open plots
                                        if s == numel(GContactBegin_MoCapFrameNumbers(:,q))


                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Joint Torque into Braking and Propulsion Phases' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )

                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Check Splitting of Joint Torque into Braking and Propulsion Phases')

                                            %Set data for the first subplot - ankle torque, absorption
                                            %phase
                                            subplot(3,2,1)
                                            plot(TimeVector_PowerAbsorption, AnkleSagittalTorque_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Torque - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque (N-m/kg) [ - = PF, + = DF ]','FontSize',14)
                                            ylim( [ -4, 4] )
                                            legend('Location','bestoutside')

                                            %Set data for the second subplot - ankle torque, generation
                                            %phase
                                            subplot(3,2,2)
                                            plot(TimeVector_PowerGeneration, AnkleSagittalTorque_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Torque - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque (N-m/kg) [ - = PF, + = DF ]','FontSize',14)
                                            ylim( [ -4, 4] )
                                            legend('Location','bestoutside')







                                            %Set data for the 3rd subplot - knee torque, absorption
                                            %phase
                                            subplot(3,2,3)
                                            plot(TimeVector_PowerAbsorption, KneeSagittalTorque_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Torque - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque (N-m/kg) [ - = Ext, + = Flex ]','FontSize',14)
                                            ylim( [ -4, 4] )
                                            legend('Location','bestoutside')

                                            %Set data for the 4th subplot - knee torque, generation
                                            %phase
                                            subplot(3,2,4)
                                            plot(TimeVector_PowerGeneration, KneeSagittalTorque_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Torque - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque (N-m/kg) [ - = Ext, + = Flex ]','FontSize',14)
                                            ylim( [ -4, 4] )
                                            legend('Location','bestoutside')







                                            %Set data for the 5th subplot - hip torque, absorption
                                            %phase
                                            subplot(3,2,5)
                                            plot(TimeVector_PowerAbsorption, HipSagittalTorque_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Torque - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque (N-m/kg) [ - = Ext, + = Flex ]','FontSize',14)
                                            ylim( [ -4, 4] )
                                            legend('Location','bestoutside')

                                            %Set data for the 6th subplot - hip torque, generation
                                            %phase
                                            subplot(3,2,6)
                                            plot(TimeVector_PowerGeneration, HipSagittalTorque_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Torque - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel('Torque (N-m/kg) [ - = Ext, + = Flex ]','FontSize',14)
                                            ylim( [ -4, 4] )
                                            legend('Location','bestoutside')




                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'TorquePhases', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all

                                        end                                                                   






    %% Plot Joint Angular Velocity - Split into Absorption and Generation Phases

                                        %Use sprintf to create s tring vector containing the degree
                                        %symbol - the string will act as the label for y-axis of the
                                        %angular velocity time series

                                            %Ankle
                                        s_AnkleAngVel = sprintf('Angular Velocity (%c/s) [- = PF/+ = DF]',char(176));

                                            %Knee and Hip
                                        s_KneeHipAngVel = sprintf('Angular Velocity (%c/s) [- = Ext/+ = Flex]',char(176));

                                            %Pelvis
                                        s_PelvisAngVel = sprintf('Angular Velocity (%c/s) [- = Posterior/+ = Anterior]',char(176));

                                        %If s is the same as the number of hops, create plots to check whether joint angular velocity seems to be correctly split into absorption and generation phases.
                                        %%pause the code so we
                                        %can view the plot before the next plot is made. Then,
                                        %close all open plots
                                        if s == numel(GContactBegin_MoCapFrameNumbers(:,q))


                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Splitting of Joint Angular Velocity into Braking and Propulsion Phases' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )

                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Check Splitting of Joint Angular Velocity into Braking and Propulsion Phases')

                                            %Set data for the first subplot - ankle angular velocity, absorption
                                            %phase
                                            subplot(3,2,1)
                                            plot(TimeVector_PowerAbsorption, AnkleSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_AnkleAngVel,'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')

                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(3,2,2)
                                            plot(TimeVector_PowerGeneration, AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_AnkleAngVel, 'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')







                                            %Set data for the 3rd subplot - knee angular velocity, absorption
                                            %phase
                                            subplot(3,2,3)
                                            plot(TimeVector_PowerAbsorption, KneeSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')

                                            %Set data for the 4th subplot - knee angular velocity, generation
                                            %phase
                                            subplot(3,2,4)
                                            plot(TimeVector_PowerGeneration, KneeSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')







                                            %Set data for the 5th subplot - hip angular velocity, absorption
                                            %phase
                                            subplot(3,2,5)
                                            plot(TimeVector_PowerAbsorption, HipSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title( 'Hip Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')


                                            %Set data for the 6th subplot - hip angular velocity, generation
                                            %phase
                                            subplot(3,2,6)
                                            plot(TimeVector_PowerGeneration, HipSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')



                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'AngVelPhases', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all




%% Plot Ankle - Shank Angular Velocity - Split into Braking and Propulsion Phases


                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Plot Ankle and Shank Angular Velocity, Split into Braking and Propulsion Phases' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )

                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Ankle and Shank Angular Velocity, Split into Braking and Propulsion Phases')

                                            %Set data for the first subplot - ankle angular velocity, absorption
                                            %phase
                                            subplot(2, 2, 1)
                                            plot(TimeVector_PowerAbsorption, AnkleSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_AnkleAngVel,'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(2, 2, 3)
                                            plot(TimeVector_PowerAbsorption, ShankSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Shank Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_AnkleAngVel, 'FontSize',14)
                                           ylim( [-100, 500] )
                                            legend('Location','bestoutside')




                                            %Set data for the first subplot - ankle angular velocity, absorption
                                            %phase
                                            subplot(2, 2, 2)
                                            plot(TimeVector_PowerGeneration, AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Ankle Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_AnkleAngVel,'FontSize',14)
                                           ylim( [-500, 100] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(2, 2, 4)
                                            plot(TimeVector_PowerGeneration, ShankSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Shank Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_AnkleAngVel, 'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')




                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'AnkleAngVelPhases', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all



%% Plot Knee - Shank - Thigh Angular Velocity - Split into Braking and Propulsion Phases


                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Plot Knee, Shank, and Thigh Angular Velocity, Split into Braking and Propulsion Phases' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )

                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Knee, Shank, and Thigh Angular Velocity, Split into Braking and Propulsion Phases')

                                            %Set data for the first subplot - ankle angular velocity, absorption
                                            %phase
                                            subplot(3, 2, 1)
                                            plot(TimeVector_PowerAbsorption, KneeSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHipAngVel,'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(3, 2, 3)
                                            plot(TimeVector_PowerAbsorption, ShankSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Shank Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(3, 2, 5)
                                            plot(TimeVector_PowerAbsorption, ThighSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Thigh Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')





                                            %Set data for the first subplot - ankle angular velocity, absorption
                                            %phase
                                            subplot(3, 2, 2)
                                            plot(TimeVector_PowerGeneration, KneeSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Knee Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHipAngVel,'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(3, 2, 4)
                                            plot(TimeVector_PowerGeneration, ShankSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Shank Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(3, 2, 6)
                                            plot(TimeVector_PowerGeneration, ThighSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Thigh Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')




                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'KneeAngVelPhases', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all



%% Plot Hip  - Thigh - Pelvis Angular Velocity - Split into Braking and Propulsion Phases


                                            %Set the size, name, and background color of the figure
                                            figure('Color','w','Position', [-1679 31 1680 999],'Name',['Plot Hip, Thigh, and Pelvis Angular Velocity, Split into Braking and Propulsion Phases' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible',"on"  )

                                            %Set the title for the general plot (title above all subplots)
                                            sgtitle('Hip, Thigh, and Pelvis Angular Velocity, Split into Braking and Propulsion Phases')

                                            %Set data for the first subplot - ankle angular velocity, absorption
                                            %phase
                                            subplot(2, 2, 1)
                                            plot(TimeVector_PowerAbsorption, HipSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHipAngVel,'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(2, 2, 3)
                                            plot(TimeVector_PowerAbsorption, ThighSagittalAngVel_BrakingPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Thigh Angular Velocity - Braking Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-100, 500] )
                                            legend('Location','bestoutside')







                                            %Set data for the first subplot - ankle angular velocity, absorption
                                            %phase
                                            subplot(2, 2, 2)
                                            plot(TimeVector_PowerGeneration, HipSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Hip Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel(s_KneeHipAngVel,'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')


                                            %Set data for the second subplot - ankle angular velocity, generation
                                            %phase
                                            subplot(2, 2, 4)
                                            plot(TimeVector_PowerGeneration, ThighSagittalAngVel_PropulsionPhase_L5S1AsReference,'LineWidth',1.5)
                                            hold on
                                            %Create a horizontal line at y-intercept of 0
                                            L = line( [ 0  max( [ max(TimeVector_PowerAbsorption), max( TimeVector_PowerGeneration) ] ) ], [0 0]);
                                            L.LineWidth = 1.2;
                                            L.Color = 'k';
                                            hold off
                                            title('Thigh Angular Velocity - Propulsion Phase','FontSize',16)
                                            xlabel('Time (s)','FontSize',14)
                                            ylabel( s_KneeHipAngVel, 'FontSize',14)
                                            ylim( [-500, 100] )
                                            legend('Location','bestoutside')






                                            pause

                                            savefig( [ ParticipantList{n}, '_', 'HipAngVelPhases', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );

                                            close all

                                        end                                                                    
                                    
                                    end
                                    
                                    
                                    
%% Integrate Contact Phase Power and Torque Data to Obtain MEE Estimates

                                

                                %Number of loops = 1 less than the length of the absorption phase.
                                %This is because the trapezoidal integration will use two
                                %consecutive time points - if we don't subtract 1, the last loop
                                %will try to index a non-existent time point
                                for f = 1 : (NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) - 1)
                                  
                                    %Perform trapezoidal integration. Formula is 0.5 * (
                                    %height * (base 1 + base 2 ) ). Height is the time step
                                    %in between data points. Base 1 is one power value,
                                    %Base 2 is the adjacent power value
                                    AnkleContactMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( AnklePowerSagittal_IndividualHopsContactPhase( f , s)  )+ abs( AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) ) ) );
                                    
                                    KneeContactMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( KneePowerSagittal_IndividualHopsContactPhase( f, s ) ) +abs( KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) ) ) );
                                    
                                    HipContactMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( HipPowerSagittal_IndividualHopsContactPhase( f, s ) ) + abs( HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) ) ) );
                                    
                                    
                                    
                                    AnkleContactWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnklePowerSagittal_IndividualHopsContactPhase( f , s)  + AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s )  ) );
                                    
                                    KneeContactWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneePowerSagittal_IndividualHopsContactPhase( f, s ) ) +abs( KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    HipContactWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipPowerSagittal_IndividualHopsContactPhase( f, s ) ) + abs( HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    
                                    
                                    
                                    AnkleContactSagittalTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTorqueSagittal_IndividualHopsContactPhase( f , s)+ AnkleTorqueSagittal_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    KneeContactSagittalTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTorqueSagittal_IndividualHopsContactPhase( f, s ) +KneeTorqueSagittal_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    HipContactSagittalTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTorqueSagittal_IndividualHopsContactPhase( f, s ) + HipTorqueSagittal_IndividualHopsContactPhase( f + 1, s ) ) );                                    
                                    
                                    
                                    
                                    AnkleContactFrontalTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTorqueFrontal_IndividualHopsContactPhase( f , s)+ AnkleTorqueFrontal_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    KneeContactFrontalTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTorqueFrontal_IndividualHopsContactPhase( f, s ) +KneeTorqueFrontal_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    HipContactFrontalTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTorqueFrontal_IndividualHopsContactPhase( f, s ) + HipTorqueFrontal_IndividualHopsContactPhase( f + 1, s ) ) );                                    
                                    
                                    
                                    
                                    AnkleContactTransverseTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTorqueTransverse_IndividualHopsContactPhase( f , s)+ AnkleTorqueTransverse_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    KneeContactTransverseTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTorqueTransverse_IndividualHopsContactPhase( f, s ) +KneeTorqueTransverse_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                    HipContactTransverseTorqueImpulse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTorqueTransverse_IndividualHopsContactPhase( f, s ) + HipTorqueTransverse_IndividualHopsContactPhase( f + 1, s ) ) );
                                    
                                  
                                end







                                    
                                    
                                  
%% Integrate Absorption Phase Power and Torque Data to Obtain MEE Estimates

                                



                                %Neutralize joint power - set all power generation to 0
                                AnklePower_BrakingPhase_GenerationNeutralized = AnklePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                AnklePower_BrakingPhase_GenerationNeutralized( AnklePower_BrakingPhase_GenerationNeutralized > 0 ) = 0;

                                KneePower_BrakingPhase_GenerationNeutralized = KneePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                KneePower_BrakingPhase_GenerationNeutralized( KneePower_BrakingPhase_GenerationNeutralized > 0 ) = 0;

                                HipPower_BrakingPhase_GenerationNeutralized = HipPower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                HipPower_BrakingPhase_GenerationNeutralized( HipPower_BrakingPhase_GenerationNeutralized > 0 ) = 0;




                                %Neutralize joint moment - set all flexor moments to 0
                                AnkleSagittalTorque_BrakingPhase_NoFlexorTorque = AnkleSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                AnkleSagittalTorque_BrakingPhase_NoFlexorTorque( AnkleSagittalTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;

                                AnkleFrontalTorque_BrakingPhase_NoFlexorTorque = AnkleFrontalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                AnkleFrontalTorque_BrakingPhase_NoFlexorTorque( AnkleFrontalTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;

                                AnkleTransverseTorque_BrakingPhase_NoFlexorTorque = AnkleTransverseTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                AnkleTransverseTorque_BrakingPhase_NoFlexorTorque( AnkleTransverseTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;


                                KneeSagittalTorque_BrakingPhase_NoFlexorTorque = KneeSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                KneeSagittalTorque_BrakingPhase_NoFlexorTorque( KneeSagittalTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;

                                KneeFrontalTorque_BrakingPhase_NoFlexorTorque = KneeFrontalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                KneeFrontalTorque_BrakingPhase_NoFlexorTorque( KneeFrontalTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;

                                KneeTransverseTorque_BrakingPhase_NoFlexorTorque = KneeTransverseTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                KneeTransverseTorque_BrakingPhase_NoFlexorTorque( KneeTransverseTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;


                                HipSagittalTorque_BrakingPhase_NoFlexorTorque = HipSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                HipSagittalTorque_BrakingPhase_NoFlexorTorque( HipSagittalTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;

                                HipFrontalTorque_BrakingPhase_NoFlexorTorque = HipFrontalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                HipFrontalTorque_BrakingPhase_NoFlexorTorque( HipFrontalTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;

                                HipTransverseTorque_BrakingPhase_NoFlexorTorque = HipTransverseTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                HipTransverseTorque_BrakingPhase_NoFlexorTorque( HipTransverseTorque_BrakingPhase_NoFlexorTorque > 0 ) = 0;



                                %Number of loops = 1 less than the length of the absorption phase.
                                %This is because the trapezoidal integration will use two
                                %consecutive time points - if we don't subtract 1, the last loop
                                %will try to index a non-existent time point
                                for f = 1 : (LengthofBrakingPhase(s) - 1)
                                  
                                    %Perform trapezoidal integration. Formula is 0.5 * (
                                    %height * (base 1 + base 2 ) ). Height is the time step
                                    %in between data points. Base 1 is one power value,
                                    %Base 2 is the adjacent power value
                                    AnkleAbsorptionMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( AnklePower_BrakingPhase_L5S1AsReference( f , s)  )+ abs( AnklePower_BrakingPhase_L5S1AsReference( f + 1, s ) ) ) );
                                    
                                    KneeAbsorptionMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( KneePower_BrakingPhase_L5S1AsReference( f, s ) ) +abs( KneePower_BrakingPhase_L5S1AsReference( f + 1, s ) ) ) );
                                    
                                    HipAbsorptionMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( HipPower_BrakingPhase_L5S1AsReference( f, s ) ) + abs( HipPower_BrakingPhase_L5S1AsReference( f + 1, s ) ) ) );
                                    
                                    
                                    
                                    AnkleAbsorptionWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnklePower_BrakingPhase_L5S1AsReference( f , s)  + AnklePower_BrakingPhase_L5S1AsReference( f + 1, s )  ) );
                                    
                                    KneeAbsorptionWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneePower_BrakingPhase_L5S1AsReference( f, s )  + KneePower_BrakingPhase_L5S1AsReference( f + 1, s ) ) );
                                    
                                    HipAbsorptionWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipPower_BrakingPhase_L5S1AsReference( f, s )  +  HipPower_BrakingPhase_L5S1AsReference( f + 1, s ) ) );
                                    
                                    

                                    AnkleWork_Braking_GenerationNeutralized_TempVector( f ) =  0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnklePower_BrakingPhase_GenerationNeutralized( f )  + AnklePower_BrakingPhase_GenerationNeutralized( f + 1  )  ) );
                                    
                                    KneeWork_Braking_GenerationNeutralized_TempVector( f ) =  0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneePower_BrakingPhase_GenerationNeutralized( f )  + KneePower_BrakingPhase_GenerationNeutralized( f + 1  )  ) );
                                    
                                    HipWork_Braking_GenerationNeutralized_TempVector( f ) =  0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipPower_BrakingPhase_GenerationNeutralized( f )  + HipPower_BrakingPhase_GenerationNeutralized( f + 1  )  ) );





                                    
                                    
                                    AnkleTorqueImpulse_Braking_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleSagittalTorque_BrakingPhase_L5S1AsReference( f , s)+ AnkleSagittalTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleTorqueImpulse_Braking_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleFrontalTorque_BrakingPhase_L5S1AsReference( f , s)+ AnkleFrontalTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleTorqueImpulse_Braking_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTransverseTorque_BrakingPhase_L5S1AsReference( f , s)+ AnkleTransverseTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    KneeTorqueImpulse_Braking_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeSagittalTorque_BrakingPhase_L5S1AsReference( f, s ) +KneeSagittalTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeTorqueImpulse_Braking_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeFrontalTorque_BrakingPhase_L5S1AsReference( f , s)+ KneeFrontalTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeTorqueImpulse_Braking_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTransverseTorque_BrakingPhase_L5S1AsReference( f , s)+ KneeTransverseTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    HipTorqueImpulse_Braking_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipSagittalTorque_BrakingPhase_L5S1AsReference( f, s ) + HipSagittalTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipTorqueImpulse_Braking_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipFrontalTorque_BrakingPhase_L5S1AsReference( f , s)+ HipFrontalTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipTorqueImpulse_Braking_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTransverseTorque_BrakingPhase_L5S1AsReference( f , s)+ HipTransverseTorque_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    


                                    AnkleTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleSagittalTorque_BrakingPhase_NoFlexorTorque( f )+ AnkleSagittalTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    AnkleTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleFrontalTorque_BrakingPhase_NoFlexorTorque( f )+ AnkleFrontalTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    AnkleTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTransverseTorque_BrakingPhase_NoFlexorTorque( f )+ AnkleTransverseTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    
                                    KneeTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeSagittalTorque_BrakingPhase_NoFlexorTorque( f  ) +KneeSagittalTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    KneeTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeFrontalTorque_BrakingPhase_NoFlexorTorque( f )+ KneeFrontalTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    KneeTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTransverseTorque_BrakingPhase_NoFlexorTorque( f )+ KneeTransverseTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    
                                    HipTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipSagittalTorque_BrakingPhase_NoFlexorTorque( f  ) + HipSagittalTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    HipTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipFrontalTorque_BrakingPhase_NoFlexorTorque( f )+ HipFrontalTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );

                                    HipTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTransverseTorque_BrakingPhase_NoFlexorTorque( f )+ HipTransverseTorque_BrakingPhase_NoFlexorTorque( f + 1  ) ) );





                                    AnkleAbsorptionAngVel_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( f , s)+ AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleAbsorptionAngVel_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleFrontalAngVel_BrakingPhase_L5S1AsReference( f , s)+ AnkleFrontalAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleAbsorptionAngVel_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTransverseAngVel_BrakingPhase_L5S1AsReference( f , s)+ AnkleTransverseAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    KneeAbsorptionAngVel_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeSagittalAngVel_BrakingPhase_L5S1AsReference( f, s ) +KneeSagittalAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeAbsorptionAngVel_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeFrontalAngVel_BrakingPhase_L5S1AsReference( f , s)+ KneeFrontalAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeAbsorptionAngVel_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTransverseAngVel_BrakingPhase_L5S1AsReference( f , s)+ KneeTransverseAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    HipAbsorptionAngVel_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipSagittalAngVel_BrakingPhase_L5S1AsReference( f, s ) + HipSagittalAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipAbsorptionAngVel_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipFrontalAngVel_BrakingPhase_L5S1AsReference( f , s)+ HipFrontalAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipAbsorptionAngVel_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTransverseAngVel_BrakingPhase_L5S1AsReference( f , s)+ HipTransverseAngVel_BrakingPhase_L5S1AsReference( f + 1, s ) ) );


                                  
                                end
                                




 %% Integrate Generation Phase Power and Torque Data
                               



                                %Neutralize jointp power - set all power absorption to 0
                                AnklePower_PropulsionPhase_AbsorptionNeutralized = AnklePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s );
                                AnklePower_PropulsionPhase_AbsorptionNeutralized( AnklePower_PropulsionPhase_AbsorptionNeutralized < 0 ) = 0;

                                KneePower_PropulsionPhase_AbsorptionNeutralized = KneePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s );
                                KneePower_PropulsionPhase_AbsorptionNeutralized( KneePower_PropulsionPhase_AbsorptionNeutralized < 0 ) = 0;

                                HipPower_PropulsionPhase_AbsorptionNeutralized = HipPower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s );
                                HipPower_PropulsionPhase_AbsorptionNeutralized( HipPower_PropulsionPhase_AbsorptionNeutralized < 0 ) = 0;



                                %Neutralize joint moment - set all flexor moments to 0
                                AnkleSagittalTorque_PropulsionPhase_NoFlexorTorque = AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                AnkleSagittalTorque_PropulsionPhase_NoFlexorTorque( AnkleSagittalTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;

                                AnkleFrontalTorque_PropulsionPhase_NoFlexorTorque = AnkleFrontalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                AnkleFrontalTorque_PropulsionPhase_NoFlexorTorque( AnkleFrontalTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;

                                AnkleTransverseTorque_PropulsionPhase_NoFlexorTorque = AnkleTransverseTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                AnkleTransverseTorque_PropulsionPhase_NoFlexorTorque( AnkleTransverseTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;


                                KneeSagittalTorque_PropulsionPhase_NoFlexorTorque = KneeSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                KneeSagittalTorque_PropulsionPhase_NoFlexorTorque( KneeSagittalTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;

                                KneeFrontalTorque_PropulsionPhase_NoFlexorTorque = KneeFrontalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                KneeFrontalTorque_PropulsionPhase_NoFlexorTorque( KneeFrontalTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;

                                KneeTransverseTorque_PropulsionPhase_NoFlexorTorque = KneeTransverseTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                KneeTransverseTorque_PropulsionPhase_NoFlexorTorque( KneeTransverseTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;


                                HipSagittalTorque_PropulsionPhase_NoFlexorTorque = HipSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                HipSagittalTorque_PropulsionPhase_NoFlexorTorque( HipSagittalTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;

                                HipFrontalTorque_PropulsionPhase_NoFlexorTorque = HipFrontalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                HipFrontalTorque_PropulsionPhase_NoFlexorTorque( HipFrontalTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;

                                HipTransverseTorque_PropulsionPhase_NoFlexorTorque = HipTransverseTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );
                                HipTransverseTorque_PropulsionPhase_NoFlexorTorque( HipTransverseTorque_PropulsionPhase_NoFlexorTorque > 0 ) = 0;
                               
                                
                                
                                %Number of loops = 1 less than the length of the generation phase.
                                %This is because the trapezoidal integration will use two
                                %consecutive time points - if we don't subtract 1, the last loop
                                %will try to index a non-existent time point
                                for f = 1 : (LengthofPropulsionPhase(s) - 1)
                                  
                                    %The next three lines perform trapezoidal integration for the ankle, knee, and hip. Formula is 0.5 * (
                                    %height * (base 1 + base 2 ) ). Height is the time step
                                    %in between data points. Base 1 is one power value,
                                    %Base 2 is the adjacent power value. 
                                    AnkleGenerationMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( AnklePower_PropulsionPhase_L5S1AsReference( f, s ) ) + abs( AnklePower_PropulsionPhase_L5S1AsReference( f + 1, s ) ) ) );
                                    
                                    KneeGenerationMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs( KneePower_PropulsionPhase_L5S1AsReference( f, s ) ) + abs( KneePower_PropulsionPhase_L5S1AsReference( f + 1, s ) ) ) );
                                    
                                    HipGenerationMEE_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( abs(  HipPower_PropulsionPhase_L5S1AsReference( f, s ) ) + abs( HipPower_PropulsionPhase_L5S1AsReference( f + 1, s ) ) ) );
                                    
                                    
                                    
                                    AnkleGenerationWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnklePower_PropulsionPhase_L5S1AsReference( f, s ) + AnklePower_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );
                                    
                                    KneeGenerationWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneePower_PropulsionPhase_L5S1AsReference( f, s ) + KneePower_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );
                                    
                                    HipGenerationWork_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipPower_PropulsionPhase_L5S1AsReference( f, s ) + HipPower_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );
                                    


                                    AnkleWork_Propulsion_AbsorptionNeutralized_TempVector( f ) =  0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnklePower_PropulsionPhase_AbsorptionNeutralized( f  )  + AnklePower_PropulsionPhase_AbsorptionNeutralized( f + 1  )  ) );
                                    
                                    KneeWork_Propulsion_AbsorptionNeutralized_TempVector( f ) =  0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneePower_PropulsionPhase_AbsorptionNeutralized( f  )  + KneePower_PropulsionPhase_AbsorptionNeutralized( f + 1  )  ) );
                                    
                                    HipWork_Propulsion_AbsorptionNeutralized_TempVector( f ) =  0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipPower_PropulsionPhase_AbsorptionNeutralized( f  )  + HipPower_PropulsionPhase_AbsorptionNeutralized( f + 1  )  ) );


                                    
                                    
                                    AnkleTorqueImpulse_Propulsion_SagittalTempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( f, s ) + AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleTorqueImpulse_Propulsion_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleFrontalTorque_PropulsionPhase_L5S1AsReference( f , s)+ AnkleFrontalTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleTorqueImpulse_Propulsion_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTransverseTorque_PropulsionPhase_L5S1AsReference( f , s)+ AnkleTransverseTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    KneeTorqueImpulse_Propulsion_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeSagittalTorque_PropulsionPhase_L5S1AsReference( f, s ) + KneeSagittalTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeTorqueImpulse_Propulsion_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeFrontalTorque_PropulsionPhase_L5S1AsReference( f , s)+ KneeFrontalTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeTorqueImpulse_Propulsion_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTransverseTorque_PropulsionPhase_L5S1AsReference( f , s)+ KneeTransverseTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    HipTorqueImpulse_Propulsion_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* (  HipSagittalTorque_PropulsionPhase_L5S1AsReference( f, s ) + HipSagittalTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipTorqueImpulse_Propulsion_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipFrontalTorque_PropulsionPhase_L5S1AsReference( f , s)+ HipFrontalTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipTorqueImpulse_Propulsion_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTransverseTorque_PropulsionPhase_L5S1AsReference( f , s)+ HipTransverseTorque_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );


                                    


                                    AnkleTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleSagittalTorque_PropulsionPhase_NoFlexorTorque( f )+ AnkleSagittalTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    AnkleTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleFrontalTorque_PropulsionPhase_NoFlexorTorque( f )+ AnkleFrontalTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    AnkleTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTransverseTorque_PropulsionPhase_NoFlexorTorque( f )+ AnkleTransverseTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    
                                    KneeTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeSagittalTorque_PropulsionPhase_NoFlexorTorque( f  ) +KneeSagittalTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    KneeTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeFrontalTorque_PropulsionPhase_NoFlexorTorque( f )+ KneeFrontalTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    KneeTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTransverseTorque_PropulsionPhase_NoFlexorTorque( f )+ KneeTransverseTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    
                                    HipTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipSagittalTorque_PropulsionPhase_NoFlexorTorque( f  ) + HipSagittalTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    HipTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipFrontalTorque_PropulsionPhase_NoFlexorTorque( f )+ HipFrontalTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );

                                    HipTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTransverseTorque_PropulsionPhase_NoFlexorTorque( f )+ HipTransverseTorque_PropulsionPhase_NoFlexorTorque( f + 1  ) ) );






                                    AnkleGenerationAngVel_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( f, s ) + AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleGenerationAngVel_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleFrontalAngVel_PropulsionPhase_L5S1AsReference( f , s)+ AnkleFrontalAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    AnkleGenerationAngVel_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( AnkleTransverseAngVel_PropulsionPhase_L5S1AsReference( f , s)+ AnkleTransverseAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    KneeGenerationAngVel_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( f, s ) + KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeGenerationAngVel_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeFrontalAngVel_PropulsionPhase_L5S1AsReference( f , s)+ KneeFrontalAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    KneeGenerationAngVel_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( KneeTransverseAngVel_PropulsionPhase_L5S1AsReference( f , s)+ KneeTransverseAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    
                                    HipGenerationAngVel_Sagittal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* (  HipSagittalAngVel_PropulsionPhase_L5S1AsReference( f, s ) + HipSagittalAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipGenerationAngVel_Frontal_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipFrontalAngVel_PropulsionPhase_L5S1AsReference( f , s)+ HipFrontalAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                    HipGenerationAngVel_Transverse_TempVector( f ) = 0.5 .* ( ( 1 / MoCapSampHz ) .* ( HipTransverseAngVel_PropulsionPhase_L5S1AsReference( f , s)+ HipTransverseAngVel_PropulsionPhase_L5S1AsReference( f + 1, s ) ) );

                                  
                                end
                                
                                


                                
%% Calculate Total and % MEE

                                %Sum all values in AnkleContactMEE_TempVector
                                AnkleContactMEE( s ) = sum( AnkleContactMEE_TempVector );
                                %Sum all values in KneeContactMEE_TempVector
                                KneeContactMEE( s ) = sum( KneeContactMEE_TempVector );
                                %Sum all values in HipContactMEE_TempVector
                                HipContactMEE( s ) = sum( HipContactMEE_TempVector );
                                
                                %Calculate whole-limb MEE for absorption phase by summing the MEE
                                %for the ankle, knee, and hip
                                WholeLimbContactMEE( s ) =  AnkleContactMEE( s ) + KneeContactMEE( s ) + HipContactMEE( s );

                                %Calculate total MEE at only the ankle and knee
                                AnkleandKneeContactMEE( s ) = AnkleContactMEE( s ) + KneeContactMEE( s );
                                
                                %Calculate contribution of each joint to whole-limb absorption phase
                                %MEE. Do this by dividing the joint MEE by the whole-limb MEE
                                AnklePercentMEEContact( s ) = AnkleContactMEE( s ) ./ WholeLimbContactMEE( s ) ;
                                KneePercentMEEContact( s ) = KneeContactMEE( s ) ./ WholeLimbContactMEE( s ) ;
                                HipPercentMEEContact( s ) = HipContactMEE( s ) ./ WholeLimbContactMEE( s ) ;

                                %Calculate contribution of ankle and knee to ankle-knee total MEE
                                AnklePercentMEE_ofAnkleandKneeMEE_Contact(s) = AnkleContactMEE( s ) ./ AnkleandKneeContactMEE( s );
                                KneePercentMEE_ofAnkleandKneeMEE_Contact(s) = KneeContactMEE( s ) ./ AnkleandKneeContactMEE( s );


                                %Sum all values in AnkleAbsorptionMEE_TempVector
                                AnkleAbsorptionMEE( s ) = sum( AnkleAbsorptionMEE_TempVector );
                                %Sum all values in KneeAbsorptionMEE_TempVector
                                KneeAbsorptionMEE( s ) = sum( KneeAbsorptionMEE_TempVector );
                                %Sum all values in HipAbsorptionMEE_TempVector
                                HipAbsorptionMEE( s ) = sum( HipAbsorptionMEE_TempVector );
                                
                                %Calculate whole-limb MEE for absorption phase by summing the MEE
                                %for the ankle, knee, and hip
                                WholeLimbAbsorptionMEE( s ) =  AnkleAbsorptionMEE( s ) + KneeAbsorptionMEE( s ) + HipAbsorptionMEE( s );

                                %Calculate total MEE at only the ankle and knee
                                AnkleandKneeAbsorptionMEE( s ) = AnkleAbsorptionMEE( s ) + KneeAbsorptionMEE( s );
                                
                                %Calculate contribution of each joint to whole-limb absorption phase
                                %MEE. Do this by dividing the joint MEE by the whole-limb MEE
                                AnklePercentMEEAbsorption( s ) = AnkleAbsorptionMEE( s ) ./ WholeLimbAbsorptionMEE( s ) ;
                                KneePercentMEEAbsorption( s ) = KneeAbsorptionMEE( s ) ./ WholeLimbAbsorptionMEE( s ) ;
                                HipPercentMEEAbsorption( s ) = HipAbsorptionMEE( s ) ./ WholeLimbAbsorptionMEE( s ) ;
                                
                                %Calculate contribution of ankle and knee to ankle-knee total MEE
                                AnklePercentMEE_ofAnkleandKneeMEE_Braking(s) = AnkleAbsorptionMEE( s ) ./ AnkleandKneeAbsorptionMEE( s );
                                KneePercentMEE_ofAnkleandKneeMEE_Braking(s) = KneeAbsorptionMEE( s ) ./ AnkleandKneeAbsorptionMEE( s );






                                %Sum all values in AnkleAbsorptionMEE_TempVector then divide by duration
                                %of braking phase
                                AnkleAverageAbsorptionMEE( s ) = sum( AnkleAbsorptionMEE_TempVector ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                %Sum all values in KneeAbsorptionMEE_TempVector
                                KneeAverageAbsorptionMEE( s ) = sum( KneeAbsorptionMEE_TempVector ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                %Sum all values in HipAbsorptionMEE_TempVector
                                HipAverageAbsorptionMEE( s ) = sum( HipAbsorptionMEE_TempVector ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                
                                %Calculate whole-limb MEE for absorption phase by summing the MEE
                                %for the ankle, knee, and hip
                                WholeLimbAverageAbsorptionMEE( s ) =  AnkleAverageAbsorptionMEE( s ) + KneeAverageAbsorptionMEE( s ) + HipAverageAbsorptionMEE( s );

                                %Calculate total MEE at only the ankle and knee
                                AnkleandKneeAverageAbsorptionMEE( s ) = AnkleAverageAbsorptionMEE( s ) + KneeAverageAbsorptionMEE( s );
                                
                                %Calculate contribution of each joint to whole-limb absorption phase
                                %MEE. Do this by dividing the joint MEE by the whole-limb MEE
                                AnklePercentAverageMEEAbsorption( s ) = AnkleAverageAbsorptionMEE( s ) ./ WholeLimbAverageAbsorptionMEE( s ) ;
                                KneePercentAverageMEEAbsorption( s ) = KneeAverageAbsorptionMEE( s ) ./ WholeLimbAverageAbsorptionMEE( s ) ;
                                HipPercentAverageMEEAbsorption( s ) = HipAverageAbsorptionMEE( s ) ./ WholeLimbAverageAbsorptionMEE( s ) ;

                                


                                
                                %Sum all values in AnkleGenerationMEE_TempVector
                                AnkleGenerationMEE( s ) = sum( AnkleGenerationMEE_TempVector );
                                %Sum all values in KneeGenerationMEE_TempVector
                                KneeGenerationMEE( s ) = sum( KneeGenerationMEE_TempVector );
                                %Sum all values in HipGenerationMEE_TempVector
                                HipGenerationMEE( s ) = sum( HipGenerationMEE_TempVector );
                                
                                %Calculate whole-limb MEE for generation phase by summing the MEE
                                %for the ankle, knee, and hip
                                WholeLimbGenerationMEE( s ) =  AnkleGenerationMEE( s ) + KneeGenerationMEE( s ) + HipGenerationMEE( s );

                                %Calculate total MEE at only the ankle and knee
                                AnkleandKneeGenerationMEE( s ) = AnkleGenerationMEE( s ) + KneeGenerationMEE( s );
                                
                                %Calculate contribution of each joint to whole-limb generation phase
                                %MEE. Do this by dividing the joint MEE by the whole-limb MEE
                                AnklePercentMEEGeneration( s ) = AnkleGenerationMEE( s ) ./ WholeLimbGenerationMEE( s ) ;
                                KneePercentMEEGeneration( s ) = KneeGenerationMEE( s ) ./ WholeLimbGenerationMEE( s ) ;
                                HipPercentMEEGeneration( s ) = HipGenerationMEE( s ) ./ WholeLimbGenerationMEE( s ) ;
                                
                                %Calculate contribution of ankle and knee to ankle-knee total MEE
                                AnklePercentMEE_ofAnkleandKneeMEE_Propulsion(s) = AnkleGenerationMEE( s ) ./ AnkleandKneeGenerationMEE( s );
                                KneePercentMEE_ofAnkleandKneeMEE_Propulsion(s) = KneeGenerationMEE( s ) ./ AnkleandKneeGenerationMEE( s );%Sum all values in AnkleGenerationMEE_TempVector



                                AnkleAverageGenerationMEE( s ) = sum( AnkleGenerationMEE_TempVector ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                %Sum all values in KneeGenerationMEE_TempVector
                                KneeAverageGenerationMEE( s ) = sum( KneeGenerationMEE_TempVector ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                %Sum all values in HipGenerationMEE_TempVector
                                HipAverageGenerationMEE( s ) = sum( HipGenerationMEE_TempVector ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                
                                %Calculate whole-limb MEE for generation phase by summing the MEE
                                %for the ankle, knee, and hip
                                WholeLimbAverageGenerationMEE( s ) =  AnkleAverageGenerationMEE( s ) + KneeAverageGenerationMEE( s ) + HipAverageGenerationMEE( s );

                                %Calculate total MEE at only the ankle and knee
                                AnkleandKneeAverageGenerationMEE( s ) = AnkleAverageGenerationMEE( s ) + KneeAverageGenerationMEE( s );
                                
                                %Calculate contribution of each joint to whole-limb generation phase
                                %MEE. Do this by dividing the joint MEE by the whole-limb MEE
                                AnklePercentAverageMEEGeneration( s ) = AnkleAverageGenerationMEE( s ) ./ WholeLimbAverageGenerationMEE( s ) ;
                                KneePercentAverageMEEGeneration( s ) = KneeAverageGenerationMEE( s ) ./ WholeLimbAverageGenerationMEE( s ) ;
                                HipPercentAverageMEEGeneration( s ) = HipAverageGenerationMEE( s ) ./ WholeLimbAverageGenerationMEE( s ) ;
                                
                                %Calculate contribution of ankle and knee to ankle-knee total MEE
                                AnklePercentAverageMEE_ofAnkleandKneeMEE_Propulsion(s) = AnkleAverageGenerationMEE( s ) ./ AnkleandKneeAverageGenerationMEE( s );
                                KneePercentAverageMEE_ofAnkleandKneeMEE_Propulsion(s) = KneeAverageGenerationMEE( s ) ./ AnkleandKneeAverageGenerationMEE( s );





                                
%% Calculate Total Work and Limb Work Ratios

                                %Find total joint work during braking phase  when generation is neutralized
                                AnkleWork_Braking_GenerationNeutralized( s ) = sum( AnkleWork_Braking_GenerationNeutralized_TempVector );
                                KneeWork_Braking_GenerationNeutralized( s ) = sum( KneeWork_Braking_GenerationNeutralized_TempVector );
                                HipWork_Braking_GenerationNeutralized( s ) = sum( HipWork_Braking_GenerationNeutralized_TempVector );


                                %Sum work across all joints to find whole-limb work
                                WholeLimbWork_Braking_GenerationNeutralized( s ) = AnkleWork_Braking_GenerationNeutralized( s ) + KneeWork_Braking_GenerationNeutralized( s ) + HipWork_Braking_GenerationNeutralized( s );

                                %Calculate joint contributions to limb work 
                                AnkleWorkContribution_Braking_GenerationNeutralized( s ) = AnkleWork_Braking_GenerationNeutralized( s ) ./ WholeLimbWork_Braking_GenerationNeutralized( s );
                                KneeWorkContribution_Braking_GenerationNeutralized( s ) = KneeWork_Braking_GenerationNeutralized( s ) ./ WholeLimbWork_Braking_GenerationNeutralized( s );
                                HipWorkContribution_Braking_GenerationNeutralized( s ) = HipWork_Braking_GenerationNeutralized( s ) ./ WholeLimbWork_Braking_GenerationNeutralized( s );




                                %Sum all values in AnkleAbsorptionMEE_TempVector
                                AnkleAbsorptionWork( s ) = sum( AnkleAbsorptionWork_TempVector );
                                %Sum all values in KneeAbsorptionMEE_TempVector
                                KneeAbsorptionWork( s ) = sum( KneeAbsorptionWork_TempVector );
                                %Sum all values in HipAbsorptionMEE_TempVector
                                HipAbsorptionWork( s ) = sum( HipAbsorptionWork_TempVector );

                                %Sum work across all joints to find whole-limb work
                                WholeLimbWork_BrakingPhase( s ) = AnkleAbsorptionWork( s ) + KneeAbsorptionWork( s ) + HipAbsorptionWork( s );

                                %Calculate joint contributions to limb work 
                                AnkleWorkContribution_BrakingPhase( s ) = AnkleAbsorptionWork( s ) ./ WholeLimbWork_BrakingPhase( s );
                                KneeWorkContribution_BrakingPhase( s ) = KneeAbsorptionWork( s ) ./ WholeLimbWork_BrakingPhase( s );
                                HipWorkContribution_BrakingPhase( s ) = HipAbsorptionWork( s ) ./ WholeLimbWork_BrakingPhase( s );

                                
                                
                                %For the absorption work ratio, we will have the ratio of positive work to
                                %negative work. Need to use an if statement.
                                    %If only the ankle work is positive, then knee and hip work are
                                    %in denominator and ankle is in numerator
                                if AnkleAbsorptionWork( s ) > 0 && KneeAbsorptionWork( s ) < 0 && HipAbsorptionWork( s ) < 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = AnkleAbsorptionWork( s ) ./ ( KneeAbsorptionWork( s ) + HipAbsorptionWork( s ) );
                                    
                                    %If only the knee work is positive, then ankle and hip work are
                                    %in denominator and knee is in numerator
                                elseif AnkleAbsorptionWork( s ) < 0 && KneeAbsorptionWork( s ) > 0 && HipAbsorptionWork( s ) < 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = KneeAbsorptionWork( s ) ./ ( AnkleAbsorptionWork( s ) + HipAbsorptionWork( s ) );
                                    
                                    %If only the hip work is positive, then knee and ankle work are
                                    %in denominator and hip is in numerator
                                elseif AnkleAbsorptionWork( s ) < 0 && KneeAbsorptionWork( s ) < 0 && HipAbsorptionWork( s ) > 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = HipAbsorptionWork( s ) ./ ( KneeAbsorptionWork( s ) + AnkleAbsorptionWork( s ) );                                    
                                    
                                    
                                    
                                    %If only the hip work is negative, only the hip is in the
                                    %denominator
                                elseif AnkleAbsorptionWork( s ) > 0 && KneeAbsorptionWork( s ) > 0 && HipAbsorptionWork( s ) < 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = ( AnkleAbsorptionWork( s ) + KneeAbsorptionWork( s ) ) ./  HipAbsorptionWork( s ) ;

                                      %If only the ankle work is negative, only the ankle is in the
                                    %denominator
                                elseif AnkleAbsorptionWork( s ) < 0 && KneeAbsorptionWork( s ) > 0 && HipAbsorptionWork( s ) > 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = ( HipAbsorptionWork( s ) + KneeAbsorptionWork( s ) ) ./  AnkleAbsorptionWork( s ) ;
                                    
                                    %If only the knee work is negative, only the knee is in the
                                    %denominator
                                elseif AnkleAbsorptionWork( s ) > 0 && KneeAbsorptionWork( s ) < 0 && HipAbsorptionWork( s ) > 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = ( AnkleAbsorptionWork( s ) + HipAbsorptionWork( s ) ) ./  KneeAbsorptionWork( s ) ;      
                                    
                                %If all joint work is positive, the work ratio is 0    
                                elseif AnkleAbsorptionWork( s ) > 0 && KneeAbsorptionWork( s ) > 0 && HipAbsorptionWork( s ) > 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = 0;
                                    
                                %If all joint work is positive, the work ratio is 0    
                                elseif AnkleAbsorptionWork( s ) < 0 && KneeAbsorptionWork( s ) < 0 && HipAbsorptionWork( s ) < 0
                                    
                                    LimbAbsorptionWorkRatio( s ) = 0;
                                    
                                end
                                
                                
                                
                                
                                 


                                %Find total joint work during braking phase  when generation is neutralized
                                AnkleWork_Propulsion_AbsorptionNeutralized( s ) = sum(  AnkleWork_Propulsion_AbsorptionNeutralized_TempVector  );
                                KneeWork_Propulsion_AbsorptionNeutralized( s ) = sum( KneeWork_Propulsion_AbsorptionNeutralized_TempVector );
                                HipWork_Propulsion_AbsorptionNeutralized( s ) = sum( HipWork_Propulsion_AbsorptionNeutralized_TempVector );


                                %Sum work across all joints to find whole-limb work
                                WholeLimbWork_Propulsion_AbsorptionNeutralized( s ) = AnkleWork_Propulsion_AbsorptionNeutralized( s ) + KneeWork_Propulsion_AbsorptionNeutralized( s ) +...
                                    HipWork_Propulsion_AbsorptionNeutralized( s );

                                %Calculate joint contributions to limb work 
                                AnkleWorkContribution_Propulsion_AbsorptionNeutralized( s ) = AnkleWork_Propulsion_AbsorptionNeutralized( s ) ./ WholeLimbWork_Propulsion_AbsorptionNeutralized( s );
                                KneeWorkContribution_Propulsion_AbsorptionNeutralized( s ) = KneeWork_Propulsion_AbsorptionNeutralized( s ) ./ WholeLimbWork_Propulsion_AbsorptionNeutralized( s );
                                HipWorkContribution_Propulsion_AbsorptionNeutralized( s ) = HipWork_Propulsion_AbsorptionNeutralized( s ) ./ WholeLimbWork_Propulsion_AbsorptionNeutralized( s );
                                




                                
                                %Sum all values in AnkleGenerationMEE_TempVector
                                AnkleGenerationWork( s ) = sum( AnkleGenerationWork_TempVector );
                                %Sum all values in KneeGenerationMEE_TempVector
                                KneeGenerationWork( s ) = sum( KneeGenerationWork_TempVector );
                                %Sum all values in HipGenerationMEE_TempVector
                                HipGenerationWork( s ) = sum( HipGenerationWork_TempVector );


                                %Calculate ankle work ratio (positive work/negative work) using all time
                                %points. Note that there will be another work ratio using ONLY periods in
                                %which the ankle is absorbing and generating, across both braking and
                                %propulsion phases
                                AnkleWorkRatio_PropulsionvsBrakingPhase( s ) = AnkleGenerationWork( s ) / AnkleAbsorptionWork( s );
                                %Calculate ankle work ratio (positive work/negative work) using all time
                                %points. Note that there will be another work ratio using ONLY periods in
                                %which the ankle is absorbing and generating, across both braking and
                                %propulsion phases
                                KneeWorkRatio_PropulsionvsBrakingPhase( s ) = KneeGenerationWork( s ) / KneeAbsorptionWork( s );
                                %Calculate ankle work ratio (positive work/negative work) using all time
                                %points. Note that there will be another work ratio using ONLY periods in
                                %which the ankle is absorbing and generating, across both braking and
                                %propulsion phases
                                HipWorkRatio_PropulsionvsBrakingPhase( s ) = HipGenerationWork( s ) / HipAbsorptionWork( s );




                                %Sum work across all joints to find whole-limb work
                                WholeLimbWork_PropulsionPhase( s ) = AnkleGenerationWork( s ) + KneeGenerationWork( s ) + HipGenerationWork( s );

                                %Calculate joint contributions to limb work 
                                AnkleWorkContribution_PropulsionPhase( s ) = AnkleGenerationWork( s ) ./ WholeLimbWork_PropulsionPhase( s );
                                KneeWorkContribution_PropulsionPhase( s ) = KneeGenerationWork( s ) ./ WholeLimbWork_PropulsionPhase( s );
                                HipWorkContribution_PropulsionPhase( s ) = HipGenerationWork( s ) ./ WholeLimbWork_PropulsionPhase( s );


                                
                                %For the absorption work ratio, we will have the ratio of positive work to
                                %negative work. Need to use an if statement.
                                    %If only the ankle work is negative, then knee and hip work are
                                    %in numerator and ankle is in denominator
                                if AnkleGenerationWork( s ) < 0 && KneeGenerationWork( s ) > 0 && HipGenerationWork( s ) > 0
                                    
                                    LimbGenerationWorkRatio( s ) = AnkleGenerationWork( s ) ./ ( KneeGenerationWork( s ) + HipGenerationWork( s ) );
                                    
                                    %If only the knee work is negative, then ankle and hip work are
                                    %in numerator and knee is in denominator
                                elseif AnkleGenerationWork( s ) > 0 && KneeGenerationWork( s ) < 0 && HipGenerationWork( s ) > 0
                                    
                                    LimbGenerationWorkRatio( s ) = KneeGenerationWork( s ) ./ ( AnkleGenerationWork( s ) + HipGenerationWork( s ) );
                                    
                                    %If only the hip work is negative, then knee and ankle work are
                                    %in numerator and hip is in denominator
                                elseif AnkleGenerationWork( s ) > 0 && KneeGenerationWork( s ) > 0 && HipGenerationWork( s ) < 0
                                    
                                    LimbGenerationWorkRatio( s ) = HipGenerationWork( s ) ./ ( KneeGenerationWork( s ) + AnkleGenerationWork( s ) );                                    
                                    
                                    
                                    
                                    %If only the hip work is positive, only the hip is in the
                                    %denominator
                                elseif AnkleGenerationWork( s ) < 0 && KneeGenerationWork( s ) < 0 && HipGenerationWork( s ) > 0
                                    
                                    LimbGenerationWorkRatio( s ) = ( AnkleGenerationWork( s ) + KneeGenerationWork( s ) ) ./  HipGenerationWork( s ) ;

                                      %If only the ankle work is positive, only the ankle is in the
                                    %denominator
                                elseif AnkleGenerationWork( s ) > 0 && KneeGenerationWork( s ) < 0 && HipGenerationWork( s ) < 0
                                    
                                    LimbGenerationWorkRatio( s ) = ( HipGenerationWork( s ) + KneeGenerationWork( s ) ) ./  AnkleGenerationWork( s ) ;
                                    
                                    %If only the knee work is positive, only the knee is in the
                                    %denominator
                                elseif AnkleGenerationWork( s ) < 0 && KneeGenerationWork( s ) > 0 && HipGenerationWork( s ) < 0
                                    
                                    LimbGenerationWorkRatio( s ) = ( AnkleGenerationWork( s ) + HipGenerationWork( s ) ) ./  KneeGenerationWork( s ) ;      
                                    
                                %If all joint work is positive, the work ratio is 0    
                                elseif AnkleGenerationWork( s ) > 0 && KneeGenerationWork( s ) > 0 && HipGenerationWork( s ) > 0
                                    
                                    LimbGenerationWorkRatio( s ) = 0;
                                    
                                %If all joint work is positive, the work ratio is 0    
                                elseif AnkleGenerationWork( s ) < 0 && KneeGenerationWork( s ) < 0 && HipGenerationWork( s ) < 0
                                    
                                    LimbGenerationWorkRatio( s ) = 0;
                                    
                                end
                                




%% Calculate Support Moment and Power - Braking Phase                    

                                    LimbSupportMoment_BrakingPhase_AllNegativeSupportMoment= zeros( 1 );
                                    AnkleSupportMoment_BrakingPhase_AllNegativeSupportMoment= zeros( 1 );
                                    KneeSupportMoment_BrakingPhase_AllNegativeSupportMoment= zeros( 1 );
                                    HipSupportMoment_BrakingPhase_AllNegativeSupportMoment= zeros( 1 );
                                    RowtoFill_NegativeSupportMoment_BrakingPhase = 1;

                                    

                                    LimbSupportMoment_AllJointsExtensor_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );
                                    AnkleSupportMoment_AllJointsExtensor_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );
                                    KneeSupportMoment_AllJointsExtensor_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );
                                    HipSupportMoment_AllJointsExtensor_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );

                                    LimbSupportPower_BrakingPhase_AllNegativeSupportPower= zeros( 1 );
                                    AnkleSupportPower_BrakingPhase_AllNegativeSupportPower= zeros( 1 );
                                    KneeSupportPower_BrakingPhase_AllNegativeSupportPower= zeros( 1 );
                                    HipSupportPower_BrakingPhase_AllNegativeSupportPower= zeros( 1 );
                                    RowtoFill_NegativeSupportPower_BrakingPhase = 1;

                                    LimbSupportPower_AllJointsAbsorb_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );
                                    AnkleSupportPower_AllJointsAbsorb_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );
                                    KneeSupportPower_AllJointsAbsorb_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );
                                    HipSupportPower_AllJointsAbsorb_BrakingPhase = zeros( LengthofBrakingPhase(s), 1 );

                                  LimbSupportMomentTimeSeries_Braking_NoFlexorTorque = zeros( LengthofBrakingPhase(s), 1 );

                                  LimbSupportPowerTimeSeries_Braking_NoGeneration = zeros( LengthofBrakingPhase(s), 1 );
% 
%                                     AnkleSupportPower_EntireBrakingPhase( s ) = sum( AnklePower_BrakingPhase_L5S1AsReference( AnklePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ), s  ) < 0 ), s );
%                                     KneeSupportPower_EntireBrakingPhase( s ) = sum( KneePower_BrakingPhase_L5S1AsReference( KneePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ), s  ) < 0 ), s );
%                                     HipSupportPower_EntireBrakingPhase( s ) = sum( HipPower_BrakingPhase_L5S1AsReference( HipPower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ), s  ) < 0 ), s );
%                                     TotalSupportPower_EntireBrakingPhase( s ) = AnkleSupportPower_EntireBrakingPhase( s ) + KneeSupportPower_EntireBrakingPhase( s ) + HipSupportPower_EntireBrakingPhase( s );
%                                     AnkleContribution_SupportPower_EntireBrakingPhase( s ) = ( AnkleSupportPower_EntireBrakingPhase( s ) ./ TotalSupportPower_EntireBrakingPhase( s ) ) * 100;
%                                     KneeContribution_SupportPower_EntireBrakingPhase( s ) = ( KneeSupportPower_EntireBrakingPhase( s ) ./ TotalSupportPower_EntireBrakingPhase( s ) ) * 100;
%                                     HipContribution_SupportPower_EntireBrakingPhase( s ) = ( HipSupportPower_EntireBrakingPhase( s ) ./ TotalSupportPower_EntireBrakingPhase( s ) ) * 100;


                                LimbSupportMoment_TimeSeries_EntireBrakingPhase = AnkleSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s ) +...
                                    KneeSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s ) + HipSagittalTorque_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );

                                LimbSupportPower_TimeSeries_EntireBrakingPhase = AnklePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s ) +...
                                    KneePower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s ) + HipPower_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase( s ) , s );
                                
                                





                                for f = 1 : LengthofBrakingPhase(s ) 

                                    %Calculate limb support moment time series when the flexor torque
                                    %is neuralized
                                    LimbSupportMomentTimeSeries_Braking_NoFlexorTorque( f ) = AnkleSagittalTorque_BrakingPhase_NoFlexorTorque( f  ) +...
                                        KneeSagittalTorque_BrakingPhase_NoFlexorTorque( f  ) + HipSagittalTorque_BrakingPhase_NoFlexorTorque( f  );


                                    %Calculate limb support power time series when power generation
                                    %is neuralized
                                    LimbSupportPowerTimeSeries_Braking_NoGeneration( f ) = AnklePower_BrakingPhase_GenerationNeutralized( f  ) +...
                                        KneePower_BrakingPhase_GenerationNeutralized( f  ) + HipPower_BrakingPhase_GenerationNeutralized( f  );


                                    %One support moment calculation is using all time points where
                                    %support moment is negative (extensor support moment)
                                    if LimbSupportMoment_TimeSeries_EntireBrakingPhase( f ) < 0

                                        LimbSupportMoment_BrakingPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_BrakingPhase ) =...
                                            LimbSupportMoment_TimeSeries_EntireBrakingPhase( f );

                                        AnkleSupportMoment_BrakingPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_BrakingPhase ) =...
                                            AnkleSagittalTorque_BrakingPhase_L5S1AsReference( f, s );

                                        KneeSupportMoment_BrakingPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_BrakingPhase ) =...
                                            KneeSagittalTorque_BrakingPhase_L5S1AsReference( f, s );

                                        HipSupportMoment_BrakingPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_BrakingPhase ) =...
                                            HipSagittalTorque_BrakingPhase_L5S1AsReference( f, s );

                                        RowtoFill_NegativeSupportMoment_BrakingPhase = RowtoFill_NegativeSupportMoment_BrakingPhase + 1;

                                    end




                                    %Only calculate support moment for points in time where all 3 joints
                                    %show an extensor moment
                                    if AnkleSagittalTorque_BrakingPhase_L5S1AsReference( f , s) < 0 && KneeSagittalTorque_BrakingPhase_L5S1AsReference( f , s) < 0 && HipSagittalTorque_BrakingPhase_L5S1AsReference( f , s) < 0

                                        %Calculate support moment as sum of all joint moments
                                        LimbSupportMoment_AllJointsExtensor_BrakingPhase( f ) = AnkleSagittalTorque_BrakingPhase_L5S1AsReference( f , s) + KneeSagittalTorque_BrakingPhase_L5S1AsReference( f , s) +...
                                            HipSagittalTorque_BrakingPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        AnkleSupportMoment_AllJointsExtensor_BrakingPhase( f ) = AnkleSagittalTorque_BrakingPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        KneeSupportMoment_AllJointsExtensor_BrakingPhase( f ) = KneeSagittalTorque_BrakingPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        HipSupportMoment_AllJointsExtensor_BrakingPhase( f ) = HipSagittalTorque_BrakingPhase_L5S1AsReference( f , s);

                                    end


                                     %One support moment calculation is using all time points where
                                    %support moment is negative (extensor support moment)
                                    if LimbSupportPower_TimeSeries_EntireBrakingPhase( f ) < 0

                                        LimbSupportPower_BrakingPhase_AllNegativeSupportPower( RowtoFill_NegativeSupportPower_BrakingPhase ) =...
                                            LimbSupportPower_TimeSeries_EntireBrakingPhase( f );

                                        AnkleSupportPower_BrakingPhase_AllNegativeSupportPower( RowtoFill_NegativeSupportPower_BrakingPhase ) =...
                                            AnklePower_BrakingPhase_L5S1AsReference( f, s );

                                        KneeSupportPower_BrakingPhase_AllNegativeSupportPower( RowtoFill_NegativeSupportPower_BrakingPhase ) =...
                                            KneePower_BrakingPhase_L5S1AsReference( f, s );

                                        HipSupportPower_BrakingPhase_AllNegativeSupportPower( RowtoFill_NegativeSupportPower_BrakingPhase ) =...
                                            HipPower_BrakingPhase_L5S1AsReference( f, s );

                                        RowtoFill_NegativeSupportPower_BrakingPhase = RowtoFill_NegativeSupportPower_BrakingPhase + 1;

                                    end



                                    %Only calculate support power for points in time where all 3 joints
                                    %show power absorption
                                    if AnklePower_BrakingPhase_L5S1AsReference( f , s) < 0 && KneePower_BrakingPhase_L5S1AsReference( f , s) < 0 && HipPower_BrakingPhase_L5S1AsReference( f , s) < 0

                                        %Calculate support moment as sum of all joint moments
                                        LimbSupportPower_AllJointsAbsorb_BrakingPhase( f ) = AnklePower_BrakingPhase_L5S1AsReference( f , s) + KneePower_BrakingPhase_L5S1AsReference( f , s) +...
                                            HipPower_BrakingPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        AnkleSupportPower_AllJointsAbsorb_BrakingPhase( f ) = AnklePower_BrakingPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        KneeSupportPower_AllJointsAbsorb_BrakingPhase( f ) = KneePower_BrakingPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        HipSupportPower_AllJointsAbsorb_BrakingPhase( f ) = HipPower_BrakingPhase_L5S1AsReference( f , s);

                                    end

                                end



                                %Calculate total limb support moment for when hip flexor torque is
                                %neutralized
                                TotalLimbSupportMoment_Braking_NoFlexorTorque( s ) = sum( LimbSupportMomentTimeSeries_Braking_NoFlexorTorque );
                                TotalAnkleSupportMoment_Braking_NoFlexorTorque( s ) = sum( AnkleSagittalTorque_BrakingPhase_NoFlexorTorque );
                                TotalKneeSupportMoment_Braking_NoFlexorTorque( s ) = sum( KneeSagittalTorque_BrakingPhase_NoFlexorTorque );
                                TotalHipSupportMoment_Braking_NoFlexorTorque( s ) = sum( HipSagittalTorque_BrakingPhase_NoFlexorTorque );


                                %Calculate ankle contribution to total limb support moment, using all
                                %time points where support moment is negative
                                AnkleSupportMomentContribution_Braking_NoFlexorTorque( s ) = ( TotalAnkleSupportMoment_Braking_NoFlexorTorque( s ) ./ ...
                                    TotalLimbSupportMoment_Braking_NoFlexorTorque( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                KneeSupportMomentContribution_Braking_NoFlexorTorque( s ) = ( TotalKneeSupportMoment_Braking_NoFlexorTorque( s ) ./ ...
                                    TotalLimbSupportMoment_Braking_NoFlexorTorque( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                HipSupportMomentContribution_Braking_NoFlexorTorque( s ) = ( TotalHipSupportMoment_Braking_NoFlexorTorque( s )./ ...
                                    TotalLimbSupportMoment_Braking_NoFlexorTorque( s ) )*100;






                                %Calculate total limb support moment,  using all time points where
                                %support moment is extensor moment
                                TotalLimbSupportMoment_Braking_AllNegativeSupportMoment( s ) = sum( LimbSupportMoment_BrakingPhase_AllNegativeSupportMoment );
                                TotalAnkleSupportMoment_Braking_AllNegativeSupportMoment( s ) = sum( AnkleSupportMoment_BrakingPhase_AllNegativeSupportMoment );
                                TotalKneeSupportMoment_Braking_AllNegativeSupportMoment( s ) = sum( KneeSupportMoment_BrakingPhase_AllNegativeSupportMoment );
                                TotalHipSupportMoment_Braking_AllNegativeSupportMoment( s ) = sum( HipSagittalTorque_BrakingPhase_NoFlexorTorque );

                                %Calculate ankle contribution to total limb support moment, using all
                                %time points where support moment is negative
                                AnkleContribution_BrakingPhase_AllNegativeSupportMoment( s ) = ( TotalAnkleSupportMoment_Braking_AllNegativeSupportMoment( s ) ./ ...
                                    TotalLimbSupportMoment_Braking_AllNegativeSupportMoment( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                KneeContribution_BrakingPhase_AllNegativeSupportMoment( s ) = ( TotalKneeSupportMoment_Braking_AllNegativeSupportMoment( s ) ./ ...
                                    TotalLimbSupportMoment_Braking_AllNegativeSupportMoment( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                HipContribution_BrakingPhase_AllNegativeSupportMoment( s ) = ( TotalHipSupportMoment_Braking_AllNegativeSupportMoment( s )./ ...
                                    TotalLimbSupportMoment_Braking_AllNegativeSupportMoment( s ) )*100;




                                %Calculate total limb support moment
                                TotalLimbSupportMoment_AllJointsExtensor_BrakingPhase( s ) = sum( LimbSupportMoment_AllJointsExtensor_BrakingPhase );

                                %Calculate total limb support moment
                                TotalAnkleSupportMoment_AllJointsExtensor_BrakingPhase( s ) = sum( AnkleSupportMoment_AllJointsExtensor_BrakingPhase );

                                %Calculate total limb support moment
                                TotalKneeSupportMoment_AllJointsExtensor_BrakingPhase( s ) = sum( KneeSupportMoment_AllJointsExtensor_BrakingPhase );

                                %Calculate total limb support moment
                                TotalHipSupportMoment_AllJointsExtensor_BrakingPhase( s ) = sum( HipSupportMoment_AllJointsExtensor_BrakingPhase );


                                %Calculate ankle contribution to total limb support moment
                                AnkleContribution_SupportMoment_AllJointsExtensor_Braking( s ) = ( TotalAnkleSupportMoment_AllJointsExtensor_BrakingPhase( s ) ./ TotalLimbSupportMoment_AllJointsExtensor_BrakingPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support moment
                                KneeContribution_SupportMoment_AllJointsExtensor_Braking( s ) = ( TotalKneeSupportMoment_AllJointsExtensor_BrakingPhase( s ) ./ TotalLimbSupportMoment_AllJointsExtensor_BrakingPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support moment
                                HipContribution_SupportMoment_AllJointsExtensor_Braking( s ) = ( TotalHipSupportMoment_AllJointsExtensor_BrakingPhase( s ) ./ TotalLimbSupportMoment_AllJointsExtensor_BrakingPhase( s ) )*100;
                                






                                %Find the points in time at which LimbSupportMoment_BrakingPhase is at
                                %its peak.
                                PeakLimbSupportMoment_Index = find( LimbSupportMoment_AllJointsExtensor_BrakingPhase == min( LimbSupportMoment_AllJointsExtensor_BrakingPhase, [],  'omitnan' ) );

                                %Store the peak LimbSupportMoment_BrakingPhase
                                PeakSupportMoment_Temp_BrakingPhase = LimbSupportMoment_AllJointsExtensor_BrakingPhase( PeakLimbSupportMoment_Index );

                                %Find the ankle contribution to peak support moment, braking phase. Use
                                %mean() because there may be multiple points in time where support moment
                                %peaks, but joint contribution may change
                                AnkleContribution_PeakSupportMoment_BrakingPhase( s ) = mean( AnkleSupportMoment_AllJointsExtensor_BrakingPhase( PeakLimbSupportMoment_Index ) ./...
                                    PeakSupportMoment_Temp_BrakingPhase, 'omitnan' ) * 100;

                                %Find the knee contribution to peak support moment, braking phase. Use
                                %mean() because there may be multiple points in time where support moment
                                %peaks, but joint contribution may change
                                KneeContribution_PeakSupportMoment_BrakingPhase( s ) = mean( KneeSupportMoment_AllJointsExtensor_BrakingPhase( PeakLimbSupportMoment_Index ) ./...
                                    PeakSupportMoment_Temp_BrakingPhase, 'omitnan' ) * 100;

                                %Find the ankle contribution to peak support moment, braking phase. Use
                                %mean() because there may be multiple points in time where support moment
                                %peaks, but joint contribution may change
                                HipContribution_PeakSupportMoment_BrakingPhase( s ) = mean( HipSupportMoment_AllJointsExtensor_BrakingPhase( PeakLimbSupportMoment_Index ) ./...
                                    PeakSupportMoment_Temp_BrakingPhase, 'omitnan' ) * 100;
                                
                                %Store the peak LimbSupportMoment_PropulsionPhase
                                PeakSupportMoment_BrakingPhase( s ) = mean( LimbSupportMoment_AllJointsExtensor_BrakingPhase( PeakLimbSupportMoment_Index ), 'omitnan' );
                                




                                %Find the points in time at which LimbSupportPower_AllJointsAbsorb_BrakingPhase is at
                                %its peak.
                                PeakLimbSupportPower_Index = find( LimbSupportPower_AllJointsAbsorb_BrakingPhase == min( LimbSupportPower_AllJointsAbsorb_BrakingPhase, [],  'omitnan' ) );

                                %Store the peak LimbSupportPower_BrakingPhase
                                PeakSupportPower_BrakingPhase( s ) = mean( LimbSupportPower_AllJointsAbsorb_BrakingPhase( PeakLimbSupportPower_Index ), 'omitnan' );





                                TotalLimbSupportPower_Braking_AllNegativeSupportPower( s ) = sum( LimbSupportPower_BrakingPhase_AllNegativeSupportPower );
                                TotalAnkleSupportPower_Braking_AllNegativeSupportPower( s ) = sum( AnkleSupportPower_BrakingPhase_AllNegativeSupportPower );
                                TotalKneeSupportPower_Braking_AllNegativeSupportPower( s ) = sum( KneeSupportPower_BrakingPhase_AllNegativeSupportPower );
                                TotalHipSupportPower_Braking_AllNegativeSupportPower( s ) = sum( HipSupportPower_BrakingPhase_AllNegativeSupportPower );

                                %Calculate ankle contribution to total limb support Power, using all
                                %time points where support Power is negative
                                AnkleContribution_BrakingPhase_AllNegativeSupportPower( s ) = ( TotalAnkleSupportPower_Braking_AllNegativeSupportPower( s ) ./ ...
                                    TotalLimbSupportPower_Braking_AllNegativeSupportPower( s ) )*100;

                                %Calculate ankle contribution to total limb support Power using all
                                %time points where support Power is negative
                                KneeContribution_BrakingPhase_AllNegativeSupportPower( s ) = ( TotalKneeSupportPower_Braking_AllNegativeSupportPower( s ) ./ ...
                                    TotalLimbSupportPower_Braking_AllNegativeSupportPower( s ) )*100;

                                %Calculate ankle contribution to total limb support Power using all
                                %time points where support Power is negative
                                HipContribution_BrakingPhase_AllNegativeSupportPower( s ) = ( TotalHipSupportPower_Braking_AllNegativeSupportPower( s )./ ...
                                    TotalLimbSupportPower_Braking_AllNegativeSupportPower( s ) )*100;







                                


                                %Calculate total limb support Power
                                TotalLimbSupportPower_BrakingPhase( s ) = sum( LimbSupportPower_AllJointsAbsorb_BrakingPhase );

                                %Calculate total limb support Power
                                TotalAnkleSupportPower_BrakingPhase( s ) = sum( AnkleSupportPower_AllJointsAbsorb_BrakingPhase );

                                %Calculate total limb support Power
                                TotalKneeSupportPower_BrakingPhase( s ) = sum( KneeSupportPower_AllJointsAbsorb_BrakingPhase );

                                %Calculate total limb support Power
                                TotalHipSupportPower_BrakingPhase( s ) = sum( HipSupportPower_AllJointsAbsorb_BrakingPhase );



                                %Calculate ankle contribution to total limb support Power
                                AnkleContribution_SupportPower_BrakingPhase( s ) = ( TotalAnkleSupportPower_BrakingPhase( s ) ./ TotalLimbSupportPower_BrakingPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support Power
                                KneeContribution_SupportPower_BrakingPhase( s ) = ( TotalKneeSupportPower_BrakingPhase( s ) ./ TotalLimbSupportPower_BrakingPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support Power
                                HipContribution_SupportPower_BrakingPhase( s ) = ( TotalHipSupportPower_BrakingPhase( s ) ./ TotalLimbSupportPower_BrakingPhase( s ) )*100;









                                %Calculate average ankle power with any generation set to 0. Divide by
                                %number of frames in braking phase
                                AnkleAveragePower_BrakingPhase_GenerationNeutralized( s ) = AnkleWork_Braking_GenerationNeutralized( s ) ./...
                                    ( LengthofBrakingPhase(s ) ./ MoCapSampHz);

                                %Calculate average knee power with any generation set to 0. Divide by
                                %number of frames in braking phase
                                KneeAveragePower_BrakingPhase_GenerationNeutralized( s ) = KneeWork_Braking_GenerationNeutralized( s ) ./...
                                    ( LengthofBrakingPhase(s ) ./ MoCapSampHz);

                                %Calculate average hip power with any generation set to 0. Divide by
                                %number of frames in braking phase
                                HipAveragePower_BrakingPhase_GenerationNeutralized( s ) = HipWork_Braking_GenerationNeutralized( s ) ./...
                                    ( LengthofBrakingPhase(s ) ./ MoCapSampHz);

                                %Calculate total limb support Power, using average joint powers
                                LimbAveragePower_BrakingPhase_GenerationNeutralized( s ) = AnkleAveragePower_BrakingPhase_GenerationNeutralized( s ) + KneeAveragePower_BrakingPhase_GenerationNeutralized( s ) +...
                                    HipAveragePower_BrakingPhase_GenerationNeutralized( s );


                                %Calculate ankle contribution to total limb support Power, using the
                                %average powers
                                AnkleContribution_AveragePower_GenerationNeutralized( s ) = ( AnkleAveragePower_BrakingPhase_GenerationNeutralized( s ) ./...
                                    LimbAveragePower_BrakingPhase_GenerationNeutralized( s ) )*100;

                                %Calculate ankle contribution to total limb support Power, using the
                                %average powers
                                KneeContribution_AveragePower_GenerationNeutralized( s ) = ( KneeAveragePower_BrakingPhase_GenerationNeutralized( s ) ./...
                                    LimbAveragePower_BrakingPhase_GenerationNeutralized( s ) )*100;

                                %Calculate ankle contribution to total limb support Power, using the
                                %average powers
                                HipContribution_AveragePower_GenerationNeutralized( s ) = ( HipAveragePower_BrakingPhase_GenerationNeutralized( s ) ./...
                                    LimbAveragePower_BrakingPhase_GenerationNeutralized( s ) )*100;






%% Calculate Support Moment and Power - Propulsion Phase                                
                                



                                LimbSupportMoment_PropulsionPhase_AllNegativeSupportMoment= zeros( 1 );
                                AnkleSupportMoment_PropulsionPhase_AllNegativeSupportMoment= zeros( 1 );
                                KneeSupportMoment_PropulsionPhase_AllNegativeSupportMoment= zeros( 1 );
                                HipSupportMoment_PropulsionPhase_AllNegativeSupportMoment= zeros( 1 );
                                RowtoFill_NegativeSupportMoment_PropulsionPhase = 1;

                                LimbSupportMoment_AllJointsExtensor_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );
                                AnkleSupportMoment_AllJointsExtensor_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );
                                KneeSupportMoment_AllJointsExtensor_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );
                                HipSupportMoment_AllJointsExtensor_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );

                                LimbSupportPower_PropulsionPhase_AllPositiveSupportPower= zeros( 1 );
                                AnkleSupportPower_PropulsionPhase_AllPositiveSupportPower= zeros( 1 );
                                KneeSupportPower_PropulsionPhase_AllPositiveSupportPower= zeros( 1 );
                                HipSupportPower_PropulsionPhase_AllPositiveSupportPower= zeros( 1 );
                                RowtoFill_PositiveSupportPower_PropulsionPhase = 1;

                                LimbSupportPower_AllJointsGenerate_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );
                                AnkleSupportPower_AllJointsGenerate_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );
                                KneeSupportPower_AllJointsGenerate_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );
                                HipSupportPower_AllJointsGenerate_PropulsionPhase = zeros( LengthofPropulsionPhase(s), 1 );

                                LimbSupportMomentTimeSeries_Propulsion_NoFlexorTorque = zeros( LengthofPropulsionPhase(s), 1 );
                                LimbSupportPowerTimeSeries_Propulsion_AbsorptionNeutralized = zeros( LengthofPropulsionPhase(s), 1 );
% 
%                                 AnkleSupportPower_EntirePropulsionPhase( s ) = sum( AnklePower_PropulsionPhase_L5S1AsReference( AnklePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ), s  ) < 0 ), s );
%                                 KneeSupportPower_EntirePropulsionPhase( s ) = sum( KneePower_PropulsionPhase_L5S1AsReference( KneePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ), s  ) < 0 ), s );
%                                 HipSupportPower_EntirePropulsionPhase( s ) = sum( HipPower_PropulsionPhase_L5S1AsReference( HipPower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ), s  ) < 0 ), s );
%                                 TotalSupportPower_EntirePropulsionPhase( s ) = AnkleSupportPower_EntirePropulsionPhase( s ) + KneeSupportPower_EntirePropulsionPhase( s ) + HipSupportPower_EntirePropulsionPhase( s );
%                                 AnkleContribution_SupportPower_EntirePropulsionPhase( s ) = ( AnkleSupportPower_EntirePropulsionPhase( s ) ./ TotalSupportPower_EntirePropulsionPhase( s ) ) * 100;
%                                 KneeContribution_SupportPower_EntirePropulsionPhase( s ) = ( KneeSupportPower_EntirePropulsionPhase( s ) ./ TotalSupportPower_EntirePropulsionPhase( s ) ) * 100;
%                                 HipContribution_SupportPower_EntirePropulsionPhase( s ) = ( HipSupportPower_EntirePropulsionPhase( s ) ./ TotalSupportPower_EntirePropulsionPhase( s ) ) * 100;


                                LimbSupportMoment_TimeSeries_EntirePropulsionPhase = AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s ) +...
                                    KneeSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s ) + HipSagittalTorque_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );

                                LimbSupportPower_TimeSeries_EntirePropulsionPhase = AnklePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s ) +...
                                    KneePower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s ) + HipPower_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase( s ) , s );



                                

                                for f = 1 : LengthofPropulsionPhase(s) 

                                    %Calculate limb support moment time series when the hip flexor torque
                                    %is neutralized
                                    LimbSupportMomentTimeSeries_Propulsion_NoFlexorTorque( f ) = AnkleSagittalTorque_PropulsionPhase_NoFlexorTorque( f  ) +...
                                        KneeSagittalTorque_PropulsionPhase_NoFlexorTorque( f  ) + HipSagittalTorque_PropulsionPhase_NoFlexorTorque( f  );

                                    LimbSupportPowerTimeSeries_Propulsion_AbsorptionNeutralized( f ) = AnklePower_PropulsionPhase_AbsorptionNeutralized( f  ) +...
                                        KneePower_PropulsionPhase_AbsorptionNeutralized( f  ) + HipPower_PropulsionPhase_AbsorptionNeutralized( f  );

                                    %One support moment calculation is using all time points where
                                    %support moment is negative (extensor support moment)
                                    if LimbSupportMoment_TimeSeries_EntirePropulsionPhase( f ) < 0

                                        LimbSupportMoment_PropulsionPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_PropulsionPhase ) =...
                                            LimbSupportMoment_TimeSeries_EntirePropulsionPhase( f );

                                        AnkleSupportMoment_PropulsionPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_PropulsionPhase ) =...
                                            AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( f, s );

                                        KneeSupportMoment_PropulsionPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_PropulsionPhase ) =...
                                            KneeSagittalTorque_PropulsionPhase_L5S1AsReference( f, s );

                                        HipSupportMoment_PropulsionPhase_AllNegativeSupportMoment( RowtoFill_NegativeSupportMoment_PropulsionPhase ) =...
                                            HipSagittalTorque_PropulsionPhase_L5S1AsReference( f, s );

                                        RowtoFill_NegativeSupportMoment_PropulsionPhase = RowtoFill_NegativeSupportMoment_PropulsionPhase + 1;

                                    end




                                    %Only calculate support moment for points in time where all 3 joints
                                    %show an extensor moment
                                    if AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( f , s) < 0 && KneeSagittalTorque_PropulsionPhase_L5S1AsReference( f , s) < 0 && HipSagittalTorque_PropulsionPhase_L5S1AsReference( f , s) < 0

                                        %Calculate support moment as sum of all joint moments
                                        LimbSupportMoment_AllJointsExtensor_PropulsionPhase( f ) = AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( f , s) + KneeSagittalTorque_PropulsionPhase_L5S1AsReference( f , s) +...
                                            HipSagittalTorque_PropulsionPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        AnkleSupportMoment_AllJointsExtensor_PropulsionPhase( f ) = AnkleSagittalTorque_PropulsionPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        KneeSupportMoment_AllJointsExtensor_PropulsionPhase( f ) = KneeSagittalTorque_PropulsionPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        HipSupportMoment_AllJointsExtensor_PropulsionPhase( f ) = HipSagittalTorque_PropulsionPhase_L5S1AsReference( f , s);

                                    end


                                     %One support moment calculation is using all time points where
                                    %sum of power is positive (entire limb generates power)
                                    if LimbSupportPower_TimeSeries_EntirePropulsionPhase( f ) > 0

                                        LimbSupportPower_PropulsionPhase_AllPositiveSupportPower( RowtoFill_PositiveSupportPower_PropulsionPhase ) =...
                                            LimbSupportPower_TimeSeries_EntirePropulsionPhase( f );

                                        AnkleSupportPower_PropulsionPhase_AllPositiveSupportPower( RowtoFill_PositiveSupportPower_PropulsionPhase ) =...
                                            AnklePower_PropulsionPhase_L5S1AsReference( f, s );

                                        KneeSupportPower_PropulsionPhase_AllPositiveSupportPower( RowtoFill_PositiveSupportPower_PropulsionPhase ) =...
                                            KneePower_PropulsionPhase_L5S1AsReference( f, s );

                                        HipSupportPower_PropulsionPhase_AllPositiveSupportPower( RowtoFill_PositiveSupportPower_PropulsionPhase ) =...
                                            HipPower_PropulsionPhase_L5S1AsReference( f, s );

                                        RowtoFill_PositiveSupportPower_PropulsionPhase = RowtoFill_PositiveSupportPower_PropulsionPhase + 1;

                                    end




                                    %Only calculate support power for points in time where all 3 joints
                                    %show power absorption
                                    if AnklePower_PropulsionPhase_L5S1AsReference( f , s) > 0 && KneePower_PropulsionPhase_L5S1AsReference( f , s) > 0 && HipPower_PropulsionPhase_L5S1AsReference( f , s) > 0

                                        %Calculate support moment as sum of all joint moments
                                        LimbSupportPower_AllJointsGenerate_PropulsionPhase( f ) = AnklePower_PropulsionPhase_L5S1AsReference( f , s) + KneePower_PropulsionPhase_L5S1AsReference( f , s) +...
                                            HipPower_PropulsionPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        AnkleSupportPower_AllJointsGenerate_PropulsionPhase( f ) = AnklePower_PropulsionPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        KneeSupportPower_AllJointsGenerate_PropulsionPhase( f ) = KneePower_PropulsionPhase_L5S1AsReference( f , s);

                                        %Add ankle moment for current frame, to AnkleSupportMoment - will
                                        %allow calculation of contribution to total support moment
                                        HipSupportPower_AllJointsGenerate_PropulsionPhase( f ) = HipPower_PropulsionPhase_L5S1AsReference( f , s);

                                    end

                                end





                                %Calculate total limb support moment for when hip flexor torque is
                                %neutralized
                                TotalLimbSupportMoment_Propulsion_NoFlexorTorque( s ) = sum( LimbSupportMomentTimeSeries_Propulsion_NoFlexorTorque );
                                TotalAnkleSupportMoment_Propulsion_NoFlexorTorque( s ) = sum( AnkleSagittalTorque_PropulsionPhase_NoFlexorTorque );
                                TotalKneeSupportMoment_Propulsion_NoFlexorTorque( s ) = sum( KneeSagittalTorque_PropulsionPhase_NoFlexorTorque );
                                TotalHipSupportMoment_Propulsion_NoFlexorTorque( s ) = sum( HipSagittalTorque_PropulsionPhase_NoFlexorTorque );


                                %Calculate ankle contribution to total limb support moment, using all
                                %time points where support moment is negative
                                AnkleSupportMomentContribution_Propulsion_NoFlexorTorque( s ) = ( TotalAnkleSupportMoment_Propulsion_NoFlexorTorque( s ) ./ ...
                                    TotalLimbSupportMoment_Propulsion_NoFlexorTorque( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                KneeSupportMomentContribution_Propulsion_NoFlexorTorque( s ) = ( TotalKneeSupportMoment_Propulsion_NoFlexorTorque( s ) ./ ...
                                    TotalLimbSupportMoment_Propulsion_NoFlexorTorque( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                HipSupportMomentContribution_Propulsion_NoFlexorTorque( s ) = ( TotalHipSupportMoment_Propulsion_NoFlexorTorque( s )./ ...
                                    TotalLimbSupportMoment_Propulsion_NoFlexorTorque( s ) )*100;



                                TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment( s ) = sum( LimbSupportMoment_PropulsionPhase_AllNegativeSupportMoment );
                                TotalAnkleSupportMoment_Propulsion_AllNegativeSupportMoment( s ) = sum( AnkleSupportMoment_PropulsionPhase_AllNegativeSupportMoment );
                                TotalKneeSupportMoment_Propulsion_AllNegativeSupportMoment( s ) = sum( KneeSupportMoment_PropulsionPhase_AllNegativeSupportMoment );
                                TotalHipSupportMoment_Propulsion_AllNegativeSupportMoment( s ) = sum( HipSupportMoment_PropulsionPhase_AllNegativeSupportMoment );

                                %Calculate ankle contribution to total limb support moment, using all
                                %time points where support moment is negative
                                AnkleContribution_PropulsionPhase_AllNegativeSupportMoment( s ) = ( TotalAnkleSupportMoment_Propulsion_AllNegativeSupportMoment( s ) ./ ...
                                    TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                KneeContribution_PropulsionPhase_AllNegativeSupportMoment( s ) = ( TotalKneeSupportMoment_Propulsion_AllNegativeSupportMoment( s ) ./ ...
                                    TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment( s ) )*100;

                                %Calculate ankle contribution to total limb support moment using all
                                %time points where support moment is negative
                                HipContribution_PropulsionPhase_AllNegativeSupportMoment( s ) = ( TotalHipSupportMoment_Propulsion_AllNegativeSupportMoment( s )./ ...
                                    TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment( s ) )*100;





                                %Calculate total limb support moment
                                TotalLimbSupportMoment_AllJointsExtensor_PropulsionPhase( s ) = sum( LimbSupportMoment_AllJointsExtensor_PropulsionPhase );

                                %Calculate total limb support moment
                                TotalAnkleSupportMoment_AllJointsExtensor_PropulsionPhase( s ) = sum( AnkleSupportMoment_AllJointsExtensor_PropulsionPhase );

                                %Calculate total limb support moment
                                TotalKneeSupportMoment_AllJointsExtensor_PropulsionPhase( s ) = sum( KneeSupportMoment_AllJointsExtensor_PropulsionPhase );

                                %Calculate total limb support moment
                                TotalHipSupportMoment_AllJointsExtensor_PropulsionPhase( s ) = sum( HipSupportMoment_AllJointsExtensor_PropulsionPhase );




                                %Calculate ankle contribution to total limb support moment
                                AnkleContribution_SupportMoment_AllJointsExtensor_Propulsion( s ) = ( TotalAnkleSupportMoment_AllJointsExtensor_PropulsionPhase( s ) ./ TotalLimbSupportMoment_AllJointsExtensor_PropulsionPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support moment
                                KneeContribution_SupportMoment_AllJointsExtensor_Propulsion( s ) = ( TotalKneeSupportMoment_AllJointsExtensor_PropulsionPhase( s ) ./ TotalLimbSupportMoment_AllJointsExtensor_PropulsionPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support moment
                                HipContribution_SupportMoment_AllJointsExtensor_Propulsion( s ) = ( TotalHipSupportMoment_AllJointsExtensor_PropulsionPhase( s ) ./ TotalLimbSupportMoment_AllJointsExtensor_PropulsionPhase( s ) )*100;
                                






                                %Find the points in time at which LimbSupportMoment_PropulsionPhase is at
                                %its peak.
                                PeakLimbSupportMoment_Index = find( LimbSupportMoment_AllJointsExtensor_PropulsionPhase == min( LimbSupportMoment_AllJointsExtensor_PropulsionPhase, [],  'omitnan' ) );

                                %Store the peak LimbSupportMoment_PropulsionPhase
                                PeakSupportMoment_Temp_PropulsionPhase = LimbSupportMoment_AllJointsExtensor_PropulsionPhase( PeakLimbSupportMoment_Index );

                                %Find the ankle contribution to peak support moment, Propulsion phase. Use
                                %mean() because there may be multiple points in time where support moment
                                %peaks, but joint contribution may change
                                AnkleContribution_PeakSupportMoment_PropulsionPhase( s ) = mean( AnkleSupportMoment_AllJointsExtensor_PropulsionPhase( PeakLimbSupportMoment_Index ) ./...
                                    PeakSupportMoment_Temp_PropulsionPhase, 'omitnan' ) * 100;

                                %Find the knee contribution to peak support moment, Propulsion phase. Use
                                %mean() because there may be multiple points in time where support moment
                                %peaks, but joint contribution may change
                                KneeContribution_PeakSupportMoment_PropulsionPhase( s ) = mean( KneeSupportMoment_AllJointsExtensor_PropulsionPhase( PeakLimbSupportMoment_Index ) ./...
                                    PeakSupportMoment_Temp_PropulsionPhase, 'omitnan' ) * 100;

                                %Find the ankle contribution to peak support moment, Propulsion phase. Use
                                %mean() because there may be multiple points in time where support moment
                                %peaks, but joint contribution may change
                                HipContribution_PeakSupportMoment_PropulsionPhase( s ) = mean( HipSupportMoment_AllJointsExtensor_PropulsionPhase( PeakLimbSupportMoment_Index ) ./...
                                    PeakSupportMoment_Temp_PropulsionPhase, 'omitnan' ) * 100;
                                
                                %Store the peak LimbSupportMoment_PropulsionPhase
                                PeakSupportMoment_PropulsionPhase( s ) = mean( LimbSupportMoment_AllJointsExtensor_PropulsionPhase( PeakLimbSupportMoment_Index ), 'omitnan' );
                                






                                TotalLimbSupportPower_Propulsion_AllPositiveSupportPower( s ) = sum( LimbSupportPower_PropulsionPhase_AllPositiveSupportPower );
                                TotalAnkleSupportPower_Propulsion_AllPositiveSupportPower( s ) = sum( AnkleSupportPower_PropulsionPhase_AllPositiveSupportPower );
                                TotalKneeSupportPower_Propulsion_AllPositiveSupportPower( s ) = sum( KneeSupportPower_PropulsionPhase_AllPositiveSupportPower );
                                TotalHipSupportPower_Propulsion_AllPositiveSupportPower( s ) = sum( HipSupportPower_PropulsionPhase_AllPositiveSupportPower );

                                %Calculate ankle contribution to total limb support Power, using all
                                %time points where support Power is negative
                                AnkleContribution_PropulsionPhase_AllPositiveSupportPower( s ) = ( TotalAnkleSupportPower_Propulsion_AllPositiveSupportPower( s ) ./ ...
                                    TotalLimbSupportPower_Propulsion_AllPositiveSupportPower( s ) )*100;

                                %Calculate ankle contribution to total limb support Power using all
                                %time points where support Power is negative
                                KneeContribution_PropulsionPhase_AllPositiveSupportPower( s ) = ( TotalKneeSupportPower_Propulsion_AllPositiveSupportPower( s ) ./ ...
                                    TotalLimbSupportPower_Propulsion_AllPositiveSupportPower( s ) )*100;

                                %Calculate ankle contribution to total limb support Power using all
                                %time points where support Power is negative
                                HipContribution_PropulsionPhase_AllPositiveSupportPower( s ) = ( TotalHipSupportPower_Propulsion_AllPositiveSupportPower( s )./ ...
                                    TotalLimbSupportPower_Propulsion_AllPositiveSupportPower( s ) )*100;










                                %Calculate total limb support Power
                                TotalLimbSupportPower_PropulsionPhase( s ) = sum( LimbSupportPower_AllJointsGenerate_PropulsionPhase );

                                %Calculate total limb support Power
                                TotalAnkleSupportPower_PropulsionPhase( s ) = sum( AnkleSupportPower_AllJointsGenerate_PropulsionPhase );

                                %Calculate total limb support Power
                                TotalKneeSupportPower_PropulsionPhase( s ) = sum( KneeSupportPower_AllJointsGenerate_PropulsionPhase );

                                %Calculate total limb support Power
                                TotalHipSupportPower_PropulsionPhase( s ) = sum( HipSupportPower_AllJointsGenerate_PropulsionPhase );


                                %Calculate ankle contribution to total limb support Power
                                AnkleContribution_SupportPower_PropulsionPhase( s ) = ( TotalAnkleSupportPower_PropulsionPhase( s ) ./ TotalLimbSupportPower_PropulsionPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support Power
                                KneeContribution_SupportPower_PropulsionPhase( s ) = ( TotalKneeSupportPower_PropulsionPhase( s ) ./ TotalLimbSupportPower_PropulsionPhase( s ) )*100;

                                %Calculate ankle contribution to total limb support Power
                                HipContribution_SupportPower_PropulsionPhase( s ) = ( TotalHipSupportPower_PropulsionPhase( s ) ./ TotalLimbSupportPower_PropulsionPhase( s ) )*100;
                                
                                








                                %Calculate total limb support Power
                                AnkleAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) = AnkleWork_Propulsion_AbsorptionNeutralized( s ) ./...
                                    ( LengthofPropulsionPhase(s ) ./ MoCapSampHz);

                                %Calculate total limb support Power
                                KneeAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) = KneeWork_Propulsion_AbsorptionNeutralized( s ) ./...
                                    ( LengthofPropulsionPhase(s ) ./ MoCapSampHz);

                                %Calculate total limb support Power
                                HipAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) = HipWork_Propulsion_AbsorptionNeutralized( s ) ./...
                                    ( LengthofPropulsionPhase(s ) ./ MoCapSampHz);

                                %Calculate total limb support Power, using the
                                %average powers
                                LimbAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) = AnkleAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) + KneeAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) +...
                                    HipAveragePower_PropulsionPhase_AbsorptionNeutralized( s );


                                %Calculate ankle contribution to total limb support Power, using the
                                %average powers
                                AnkleContribution_AveragePower_AbsorptionNeutralized( s ) = ( AnkleAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) ./...
                                    LimbAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) )*100;

                                %Calculate ankle contribution to total limb support Power, using the
                                %average powers
                                KneeContribution_AveragePower_AbsorptionNeutralized( s ) = ( KneeAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) ./...
                                    LimbAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) )*100;

                                %Calculate ankle contribution to total limb support Power, using the
                                %average powers
                                HipContribution_AveragePower_AbsorptionNeutralized( s ) = ( HipAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) ./...
                                    LimbAveragePower_PropulsionPhase_AbsorptionNeutralized( s ) )*100;







                                
%% Calculate Total Joint Torque Impulse


                                 %Sum all values in AnkleContactTorqueImpulse_TempVector
                                AnkleContactSagittalTorqueImpulse( s ) = sum( AnkleContactSagittalTorqueImpulse_TempVector );
                                %Sum all values in KneeContactTorqueImpulse_TempVector
                                KneeContactSagittalTorqueImpulse( s ) = sum( KneeContactSagittalTorqueImpulse_TempVector );
                                %Sum all values in HipContactTorqueImpulse_TempVector
                                HipContactSagittalTorqueImpulse( s ) = sum( HipContactSagittalTorqueImpulse_TempVector );   


                                %Sum all values in AnkleContactTorqueImpulse_TempVector
                                AnkleContactFrontalTorqueImpulse( s ) = sum( AnkleContactFrontalTorqueImpulse_TempVector );
                                %Sum all values in KneeContactTorqueImpulse_TempVector
                                KneeContactFrontalTorqueImpulse( s ) = sum( KneeContactFrontalTorqueImpulse_TempVector );
                                %Sum all values in HipContactTorqueImpulse_TempVector
                                HipContactFrontalTorqueImpulse( s ) = sum( HipContactFrontalTorqueImpulse_TempVector );   


                                %Sum all values in AnkleContactTorqueImpulse_TempVector
                                AnkleContactTransverseTorqueImpulse( s ) = sum( AnkleContactTransverseTorqueImpulse_TempVector );
                                %Sum all values in KneeContactTorqueImpulse_TempVector
                                KneeContactTransverseTorqueImpulse( s ) = sum( KneeContactTransverseTorqueImpulse_TempVector );
                                %Sum all values in HipContactTorqueImpulse_TempVector
                                HipContactTransverseTorqueImpulse( s ) = sum( HipContactTransverseTorqueImpulse_TempVector );   




                                 %Sum all values in AnkleTorqueImpulse_Braking_TempVector
                                AnkleTorqueImpulse_Braking_Sagittal_NoFlexTorq( s ) = sum( AnkleTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector );
                                AnkleTorqueImpulse_Braking_Frontal_NoFlexTorq( s ) = sum( AnkleTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector );
                                AnkleTorqueImpulse_Braking_Transverse_NoFlexTorq( s ) = sum( AnkleTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector );
                                %Sum all values in KneeTorqueImpulse_Braking_TempVector
                                KneeTorqueImpulse_Braking_Sagittal_NoFlexTorq( s ) = sum( KneeTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector );
                                KneeTorqueImpulse_Braking_Frontal_NoFlexTorq( s ) = sum( KneeTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector );
                                KneeTorqueImpulse_Braking_Transverse_NoFlexTorq( s ) = sum( KneeTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector );
                                %Sum all values in HipTorqueImpulse_Braking_TempVector
                                HipTorqueImpulse_Braking_Sagittal_NoFlexTorq( s ) = sum( HipTorqueImpulse_Braking_Sagittal_NoFlexTorq_TempVector );    
                                HipTorqueImpulse_Braking_Frontal_NoFlexTorq( s ) = sum( HipTorqueImpulse_Braking_Frontal_NoFlexTorq_TempVector );
                                HipTorqueImpulse_Braking_Transverse_NoFlexTorq( s ) = sum( HipTorqueImpulse_Braking_Transverse_NoFlexTorq_TempVector );       


                                %Calculate average torque impulse for braking phase
                                AnkleAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) = AnkleTorqueImpulse_Braking_Sagittal_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                AnkleAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) = AnkleTorqueImpulse_Braking_Frontal_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                AnkleAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) = AnkleTorqueImpulse_Braking_Transverse_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                KneeAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) = KneeTorqueImpulse_Braking_Sagittal_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                KneeAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) = KneeTorqueImpulse_Braking_Frontal_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                KneeAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) = KneeTorqueImpulse_Braking_Transverse_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                HipAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) = HipTorqueImpulse_Braking_Sagittal_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                HipAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) = HipTorqueImpulse_Braking_Frontal_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                HipAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) = HipTorqueImpulse_Braking_Transverse_NoFlexTorq( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                
                                
                                %Sum all values in AnkleTorqueImpulse_Propulsion_TempVector
                                AnkleTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s ) = sum( AnkleTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector );
                                AnkleTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s ) = sum( AnkleTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector );
                                AnkleTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s ) = sum( AnkleTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector );
                                %Sum all values in KneeTorqueImpulse_Propulsion_TempVector
                                KneeTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s ) = sum( KneeTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector );
                                KneeTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s ) = sum( KneeTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector );
                                KneeTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s ) = sum( KneeTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector );
                                %Sum all values in HipTorqueImpulse_Propulsion_TempVector
                                HipTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s ) = sum( HipTorqueImpulse_Propulsion_Sagittal_NoFlexTorq_TempVector );
                                HipTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s ) = sum( HipTorqueImpulse_Propulsion_Frontal_NoFlexTorq_TempVector );
                                HipTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s ) = sum( HipTorqueImpulse_Propulsion_Transverse_NoFlexTorq_TempVector );


                                %Calculate average torque impulse for braking phase
                                AnkleAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) = AnkleTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                AnkleAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) = AnkleTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                AnkleAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) = AnkleTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                KneeAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) = KneeTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                KneeAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) = KneeTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                KneeAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) = KneeTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                HipAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) = HipTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                HipAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) = HipTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                HipAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) = HipTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );









                                 %Sum all values in AnkleTorqueImpulse_Braking_TempVector
                                AnkleTorqueImpulse_Braking_Sagittal( s ) = sum( AnkleTorqueImpulse_Braking_Sagittal_TempVector );
                                AnkleTorqueImpulse_Braking_Frontal( s ) = sum( AnkleTorqueImpulse_Braking_Frontal_TempVector );
                                AnkleTorqueImpulse_Braking_Transverse( s ) = sum( AnkleTorqueImpulse_Braking_Transverse_TempVector );
                                %Sum all values in KneeTorqueImpulse_Braking_TempVector
                                KneeTorqueImpulse_Braking_Sagittal( s ) = sum( KneeTorqueImpulse_Braking_Sagittal_TempVector );
                                KneeTorqueImpulse_Braking_Frontal( s ) = sum( KneeTorqueImpulse_Braking_Frontal_TempVector );
                                KneeTorqueImpulse_Braking_Transverse( s ) = sum( KneeTorqueImpulse_Braking_Transverse_TempVector );
                                %Sum all values in HipTorqueImpulse_Braking_TempVector
                                HipTorqueImpulse_Braking_Sagittal( s ) = sum( HipTorqueImpulse_Braking_Sagittal_TempVector );    
                                HipTorqueImpulse_Braking_Frontal( s ) = sum( HipTorqueImpulse_Braking_Frontal_TempVector );
                                HipTorqueImpulse_Braking_Transverse( s ) = sum( HipTorqueImpulse_Braking_Transverse_TempVector );       


                                %Calculate average torque impulse for braking phase
                                AnkleAverageBrakingTorqueImpulse_Sagittal( s ) = AnkleTorqueImpulse_Braking_Sagittal( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                KneeAverageBrakingTorqueImpulse_Sagittal( s ) = KneeTorqueImpulse_Braking_Sagittal( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                HipAverageBrakingTorqueImpulse_Sagittal( s ) = HipTorqueImpulse_Braking_Sagittal( s ) ./ ( LengthofBrakingPhase(s) ./ MoCapSampHz );
                                
                                

                                %Sum all values in AnkleTorqueImpulse_Propulsion_TempVector
                                AnkleTorqueImpulse_Propulsion_Sagittal( s ) = sum( AnkleTorqueImpulse_Propulsion_SagittalTempVector );
                                AnkleTorqueImpulse_Propulsion_Frontal( s ) = sum( AnkleTorqueImpulse_Propulsion_Frontal_TempVector );
                                AnkleTorqueImpulse_Propulsion_Transverse( s ) = sum( AnkleTorqueImpulse_Propulsion_Transverse_TempVector );
                                %Sum all values in KneeTorqueImpulse_Propulsion_TempVector
                                KneeTorqueImpulse_Propulsion_Sagittal( s ) = sum( KneeTorqueImpulse_Propulsion_Sagittal_TempVector );
                                KneeTorqueImpulse_Propulsion_Frontal( s ) = sum( KneeTorqueImpulse_Propulsion_Frontal_TempVector );
                                KneeTorqueImpulse_Propulsion_Transverse( s ) = sum( KneeTorqueImpulse_Propulsion_Transverse_TempVector );
                                %Sum all values in HipTorqueImpulse_Propulsion_TempVector
                                HipTorqueImpulse_Propulsion_Sagittal( s ) = sum( HipTorqueImpulse_Propulsion_Sagittal_TempVector );
                                HipTorqueImpulse_Propulsion_Frontal( s ) = sum( HipTorqueImpulse_Propulsion_Frontal_TempVector );
                                HipTorqueImpulse_Propulsion_Transverse( s ) = sum( HipTorqueImpulse_Propulsion_Transverse_TempVector );


                                %Calculate average torque impulse for braking phase
                                AnkleAveragePropulsionTorqueImpulse_Sagittal( s ) = AnkleTorqueImpulse_Propulsion_Sagittal( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                KneeAveragePropulsionTorqueImpulse_Sagittal( s ) = KneeTorqueImpulse_Propulsion_Sagittal( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );
                                %Calculate average torque impulse for braking phase
                                HipAveragePropulsionTorqueImpulse_Sagittal( s ) = HipTorqueImpulse_Propulsion_Sagittal( s ) ./ ( LengthofPropulsionPhase(s) ./ MoCapSampHz );




%% Calculate Joint Torque Impulse Contribution

                                %Calculate total limb average torque impulse, using the torque impulse
                                %with flexor torque set to 0
                                        %Braking Phase
                                                %Sagittal Plane
                                TotalLimbAverageTorqueImpulse_Braking_Sagittal_NoFlexTorq( s ) = AnkleAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) +...
                                    KneeAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) + HipAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s );
                                                %Frontal Plane
                                TotalLimbAverageTorqueImpulse_Braking_Frontal_NoFlexTorq( s ) = AnkleAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) +...
                                    KneeAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) + HipAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s );
                                                %Transverse Plane
                                TotalLimbAverageTorqueImpulse_Braking_Transverse_NoFlexTorq( s ) = AnkleAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) +...
                                    KneeAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) + HipAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s );


                                        %Propulsion Phase
                                                %Sagittal Plane
                                TotalLimbAverageTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s ) = AnkleAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) +...
                                    KneeAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) + HipAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s );
                                                %Frontal Plane
                                TotalLimbAverageTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s ) = AnkleAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) +...
                                    KneeAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) + HipAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s );
                                                %Transverse Plane
                                TotalLimbAverageTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s ) = AnkleAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) +...
                                    KneeAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) + HipAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s );


                                %Calculate ANKLE contribution to total limb average torque impulse, using
                                %the torque impulse with flexor torque set to 0
                                        %Braking phase
                                                %Sagittal plane
                                AnkleContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq( s ) = AnkleAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Sagittal_NoFlexTorq( s );
                                                %Frontal plane
                                AnkleContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq( s ) = AnkleAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Frontal_NoFlexTorq( s );
                                                %Transverse plane
                                AnkleContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq( s ) = AnkleAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Transverse_NoFlexTorq( s );

                                        %Propulsion phase
                                                %Sagittal plane
                                AnkleContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq( s ) = AnkleAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s );
                                                %Frontal plane
                                AnkleContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq( s ) = AnkleAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s );
                                                %Transverse plane
                                AnkleContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq( s ) = AnkleAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s );




                                %Calculate KNEE contribution to total limb average torque impulse, using
                                %the torque impulse with flexor torque set to 0
                                        %Braking phase
                                                %Sagittal plane
                                KneeContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq( s ) = KneeAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Sagittal_NoFlexTorq( s );
                                                %Frontal plane
                                KneeContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq( s ) = KneeAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Frontal_NoFlexTorq( s );
                                                %Transverse plane
                                KneeContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq( s ) = KneeAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Transverse_NoFlexTorq( s );

                                        %Propulsion phase
                                                %Sagittal plane
                                KneeContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq( s ) = KneeAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s );
                                                %Frontal plane
                                KneeContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq( s ) = KneeAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s );
                                                %Transverse plane
                                KneeContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq( s ) = KneeAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s );




                                %Calculate HIP contribution to total limb average torque impulse, using
                                %the torque impulse with flexor torque set to 0
                                        %Braking phase
                                                %Sagittal plane
                                HipContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq( s ) = HipAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Sagittal_NoFlexTorq( s );
                                                %Frontal plane
                                HipContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq( s ) = HipAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Frontal_NoFlexTorq( s );
                                                %Transverse plane
                                HipContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq( s ) = HipAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Braking_Transverse_NoFlexTorq( s );

                                        %Propulsion phase
                                                %Sagittal plane
                                HipContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq( s ) = HipAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s );
                                                %Frontal plane
                                HipContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq( s ) = HipAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s );
                                                %Transverse plane
                                HipContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq( s ) = HipAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s ) ./ ...
                                    TotalLimbAverageTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s );




%% Calculate Average Joint Angular Velocity

                                %Sum all values in AnkleAbsorptionAngVel_TempVector
                                AverageAnkleAbsorptionAngVel_Sagittal( s ) = sum( AnkleAbsorptionAngVel_Sagittal_TempVector ) ./ LengthofBrakingPhase_Seconds( s );
                                AverageAnkleAbsorptionAngVel_Frontal( s ) = sum( AnkleAbsorptionAngVel_Frontal_TempVector ) ./ LengthofBrakingPhase_Seconds( s );
                                AverageAnkleAbsorptionAngVel_Transverse( s ) = sum( AnkleAbsorptionAngVel_Transverse_TempVector ) ./ LengthofBrakingPhase_Seconds( s );
                                %Sum all values in KneeAbsorptionAngVel_TempVector
                                AverageKneeAbsorptionAngVel_Sagittal( s ) = sum( KneeAbsorptionAngVel_Sagittal_TempVector ) ./ LengthofBrakingPhase_Seconds( s );
                                AverageKneeAbsorptionAngVel_Frontal( s ) = sum( KneeAbsorptionAngVel_Frontal_TempVector ) ./ LengthofBrakingPhase_Seconds( s );
                                AverageKneeAbsorptionAngVel_Transverse( s ) = sum( KneeAbsorptionAngVel_Transverse_TempVector ) ./ LengthofBrakingPhase_Seconds( s );
                                %Sum all values in HipAbsorptionAngVel_TempVector
                                AverageHipAbsorptionAngVel_Sagittal( s ) = sum( HipAbsorptionAngVel_Sagittal_TempVector ) ./ LengthofBrakingPhase_Seconds( s );    
                                AverageHipAbsorptionAngVel_Frontal( s ) = sum( HipAbsorptionAngVel_Frontal_TempVector ) ./ LengthofBrakingPhase_Seconds( s );
                                AverageHipAbsorptionAngVel_Transverse( s ) = sum( HipAbsorptionAngVel_Transverse_TempVector ) ./ LengthofBrakingPhase_Seconds( s );                           
                                
                                
                                %Sum all values in AnkleGenerationAngVel_TempVector
                                AverageAnkleGenerationAngVel_Sagittal( s ) = sum( AnkleGenerationAngVel_Sagittal_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                AverageAnkleGenerationAngVel_Frontal( s ) = sum( AnkleGenerationAngVel_Frontal_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                AverageAnkleGenerationAngVel_Transverse( s ) = sum( AnkleGenerationAngVel_Transverse_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                %Sum all values in KneeGenerationAngVel_TempVector
                                AverageKneeGenerationAngVel_Sagittal( s ) = sum( KneeGenerationAngVel_Sagittal_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                AverageKneeGenerationAngVel_Frontal( s ) = sum( KneeGenerationAngVel_Frontal_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                AverageKneeGenerationAngVel_Transverse( s ) = sum( KneeGenerationAngVel_Transverse_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                %Sum all values in HipGenerationAngVel_TempVector
                                AverageHipGenerationAngVel_Sagittal( s ) = sum( HipGenerationAngVel_Sagittal_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                AverageHipGenerationAngVel_Frontal( s ) = sum( HipGenerationAngVel_Frontal_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                AverageHipGenerationAngVel_Transverse( s ) = sum( HipGenerationAngVel_Transverse_TempVector ) ./ LengthofPropulsionPhase_Seconds( s );
                                
                                
                                
%% Calculate Total and % Power
        
                                   
                                  
                                    %Total negative and positive power using entire hop cycle - not just
                                    %absorption vs generation phases - for Ankle
                                    AnklePowerSagittal_NegativeFrames_EntireContactPhase = find( AnklePowerSagittal_IndividualHopsContactPhase(1: FrameofMinL5S1Position_EndBraking(s), s) < 0 );
                                    AnklePowerSagittal_PositiveFrames_EntireContactPhase = find( AnklePowerSagittal_IndividualHopsContactPhase( FrameofMinL5S1Position_BeginPropulsion(s) : NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) > 0 );                         
                                    TotalNegativePower_Ankle_EntireContactPhase(s) = sum( AnklePowerSagittal_IndividualHopsContactPhase( AnklePowerSagittal_NegativeFrames_EntireContactPhase ,s) );
                                    TotalPositivePower_Ankle_EntireContactPhase(s) = sum( AnklePowerSagittal_IndividualHopsContactPhase( AnklePowerSagittal_PositiveFrames_EntireContactPhase ,s) );
   
                                    
%% FIND All  Periods of Positive/Negative Work - Ankle                                    
                                    
                                    
                                    %Initialize variables to hold the beginning and end of each
                                    %period of ankle power absorption and generation
                                    BeginningofAnklePowerGeneration = NaN( 1, 1);
                                    BeginningofAnklePowerAbsorption = NaN( 1, 1);
                                    EndofAnklePowerGeneration = NaN( 1, 1);
                                    EndofAnklePowerAbsorption = NaN( 1, 1);
                                    
                                    %Will use this when finding the first frame of all periods of ankle
                                    %power generation - this will fill in the next element of BeginningofAnklePowerGeneration
                                    RowtoFill_BeginAnklePowerGeneration = 1;
                                    RowtoFill_BeginAnklePowerAbsorption = 1;
                                    RowtoFill_EndAnklePowerGeneration = 1;
                                    RowtoFill_EndAnklePowerAbsorption = 1;
                                    
                                    %Find and integrate all periods of positive and negative work. There may be
                                    %multiple periods of positive work and multiple periods of
                                    %negative work - will find integrate each period separately then
                                    %add all together to find total positive work and total negative
                                    %work.
                                    
                                    %In this next line, we are subtracting 1 from the number of
                                    %elements in the Sth hop, because the embedded If statement will
                                    %use the f and f+1st values. If we don't subtract 1, the final
                                    %loop will try to access an element that doesn't exist.
                                    for f = 1 : (NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) - 1)
                                    
                                        if f == 1
%                                             %If the first element in
%                                             %AnklePowerSagittal_IndividualHopsContactPhase is negative,
%                                             %this is the beginning of a period of power absorption
%                                             if AnklePowerSagittal_IndividualHopsContactPhase( f, s ) < 0
% 
%                                                 BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = 1;
% 
%                                                 RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;
% 
% 
%                                             %If the first element in
%                                             %AnklePowerSagittal_IndividualHopsContactPhase is positive,
%                                             %this is the beginning of a period of power generation    
%                                             elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) > 0
% 
%                                                 BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = 1;
% 
%                                                 RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;



                                            if AnklePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                                
                                                BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = 1;

                                                RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;
                                                
                                                
                                                
                                                
                                                BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = f + 1;

                                                RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;


                                                
                                                EndofAnklePowerGeneration( RowtoFill_EndAnklePowerGeneration ) = f;

                                                RowtoFill_EndAnklePowerGeneration = RowtoFill_EndAnklePowerGeneration + 1;

                                                
                                                

                                            elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) == 0

                                                
                                                BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = 1;

                                                RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;
                                                
                                                
                                                
                                                EndofAnklePowerGeneration( RowtoFill_EndAnklePowerGeneration ) = f;

                                                RowtoFill_EndAnklePowerGeneration = RowtoFill_EndAnklePowerGeneration + 1;     

                                                
                                                
                                                

                                           elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                               
                                               BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = 1;

                                                RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;
                                               
                                               
                                                
                                                BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = f + 1;

                                                RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;


                                                 EndofAnklePowerAbsorption( RowtoFill_EndAnklePowerAbsorption ) = f;

                                                RowtoFill_EndAnklePowerAbsorption = RowtoFill_EndAnklePowerAbsorption + 1;

                                                
                                                
                                                
                                                
                                             elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) == 0

                                               
                                               BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = 1;

                                                RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;
                                               
                                               


                                                 EndofAnklePowerAbsorption( RowtoFill_EndAnklePowerAbsorption ) = f;

                                                RowtoFill_EndAnklePowerAbsorption = RowtoFill_EndAnklePowerAbsorption + 1;   
                                                

                                                
                                                

                                             elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                                BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = f + 1;

                                                RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;   



                                                

                                            elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                                BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = f + 1;

                                                RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;
                                                
                                                
                                                
                                                
                                            elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                               
                                               BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = 1;

                                                RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;
                                                
                                                
                                                
                                            elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && AnklePowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                                
                                                BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = 1;

                                                RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;
                                                

                                                
                                            end
                                            
                                            
                                        
                                        
                                        elseif f~=1 
                                            
                                            if AnklePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && AnklePowerSagittal_IndividualHopsContactPhase( f+1, s ) > 0

                                                    BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = f + 1;

                                                    RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;


                                                    EndofAnklePowerAbsorption( RowtoFill_EndAnklePowerAbsorption ) = f;

                                                    RowtoFill_EndAnklePowerAbsorption = RowtoFill_EndAnklePowerAbsorption + 1;


                                                %If Element F in
                                                %AnklePowerSagittal_IndividualHopsContactPhase is greater than
                                                %or equal to 0 AND Element F+1 is less than 0, Element
                                                %F+1 marks the beginning of a period of power absorption.   
                                                %In turn, Element F markes the end of a period of power
                                                %generation
                                                elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && AnklePowerSagittal_IndividualHopsContactPhase( f+1, s ) < 0


                                                    BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = f + 1;

                                                    RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;



                                                    EndofAnklePowerGeneration( RowtoFill_EndAnklePowerGeneration ) = f;

                                                    RowtoFill_EndAnklePowerGeneration = RowtoFill_EndAnklePowerGeneration + 1;



                                               %If Element F in
                                                %AnklePowerSagittal_IndividualHopsContactPhase equals
                                                % 0 AND Element F+1 is greater than 0, Element
                                                %F+1 marks the beginning of a period of power generation.
                                                %Element F DOES NOT mark the end of power absorption, since
                                                %power absorption must end before power becomes 0
                                                elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && AnklePowerSagittal_IndividualHopsContactPhase( f+1, s ) > 0

                                                    BeginningofAnklePowerGeneration( RowtoFill_BeginAnklePowerGeneration ) = f + 1;

                                                    RowtoFill_BeginAnklePowerGeneration = RowtoFill_BeginAnklePowerGeneration + 1;



                                                %If Element F in
                                                %AnklePowerSagittal_IndividualHopsContactPhase is equal to 0 AND Element F+1 is less than 0, Element
                                                %F+1 marks the beginning of a period of power absorption.    
                                                %Element F DOES NOT mark the end of power generation, since
                                                %power generation must end before power becomes 0
                                                elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && AnklePowerSagittal_IndividualHopsContactPhase( f+1, s ) < 0


                                                    BeginningofAnklePowerAbsorption( RowtoFill_BeginAnklePowerAbsorption ) = f + 1;

                                                    RowtoFill_BeginAnklePowerAbsorption = RowtoFill_BeginAnklePowerAbsorption + 1;



                                                %If Element F in
                                                %AnklePowerSagittal_IndividualHopsContactPhase is less than
                                                %0 AND Element F+1 equals 0, Element
                                                %F marks the end of a period of power absorption.    
                                                elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && AnklePowerSagittal_IndividualHopsContactPhase( f+1, s ) == 0


                                                    EndofAnklePowerAbsorption( RowtoFill_EndAnklePowerAbsorption ) = f;

                                                    RowtoFill_EndAnklePowerAbsorption = RowtoFill_EndAnklePowerAbsorption + 1;


                                                %If Element F in
                                                %AnklePowerSagittal_IndividualHopsContactPhase is greater than
                                                %0 AND Element F+1 equals 0, Element
                                                %F marks the end of a period of power generation.    
                                                elseif AnklePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && AnklePowerSagittal_IndividualHopsContactPhase( f+1, s ) == 0

                                                    EndofAnklePowerGeneration( RowtoFill_EndAnklePowerGeneration ) = f;

                                                    RowtoFill_EndAnklePowerGeneration = RowtoFill_EndAnklePowerGeneration + 1;

                                                    
                                            end
                                            

                                            %If f = the second to last element in the hip power time
                                            %series, execute this code
                                            if f == NumEl_SthHopContactPhase_MoCapSamplingHz(s,q)-1


                                                %If the last element of
                                                %AnklePowerSagittal_IndividualHopsContactPhase is positive,
                                                %the last element marks the end of a period of power
                                                %generation
                                                if AnklePowerSagittal_IndividualHopsContactPhase( NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) > 0

                                                    EndofAnklePowerGeneration( RowtoFill_EndAnklePowerGeneration ) = NumEl_SthHopContactPhase_MoCapSamplingHz(s,q);



                                                %If the last element of
                                                %AnklePowerSagittal_IndividualHopsContactPhase is negative,
                                                %the last element marks the end of a period of power
                                                %absorption   
                                                elseif  AnklePowerSagittal_IndividualHopsContactPhase( NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) < 0

                                                    EndofAnklePowerAbsorption( RowtoFill_EndAnklePowerAbsorption ) = NumEl_SthHopContactPhase_MoCapSamplingHz(s,q);
                                                    
                                                end
                                                
                                            end
                                            
                                        end
                                        
                                    end
                                            




                                            

                                    
                                    %Initialize vectors to hold the total negative work for each period of ankle absorption.
                                    AnkleNegativeWork_CumSum = NaN( 1, 1 );
                                    LengthofAnkleAbsorption_Sec_TempVector = NaN( 1, 1 );
                                    
                                    
                                    %Calculate negative work for the ankle. First, run the outer
                                    %loop once for each period of ankle absorption
                                    for g = 1 : length( BeginningofAnklePowerAbsorption ) 
                                        
                                        %Create a vector containing the frames for the Gth period of
                                        %ankle power absorption
                                        AnkleAbsorptionFrames = BeginningofAnklePowerAbsorption( g ) : EndofAnklePowerAbsorption( g );
                                        
                                        %Find the length of the Gth period of ankle absorption, in
                                        %seconds
                                        LengthofAnkleAbsorption_Sec_TempVector( g ) = length( AnkleAbsorptionFrames ) ./ MoCapSampHz;
                                        
                                        %Initialize a vector to hold the individual data points for
                                        %negative work in the Gth period of ankle power absorptionn
                                        AnkleNegativeWork_TempVector = NaN( 1, 1);
                                        
                                        %This will tell the H loop (below) which row of
                                        %AnkleNegativeWork_TempVector to fill
                                        RowtoFill_AnkleNegativeWork = 1;
                                        
                                        
                                        if length( AnkleAbsorptionFrames ) == 1
                                            
                                            %Fill in the Gth row of AnkleNegativeWork_CumSum by summing
                                            %all data points in AnkleNegativeWork_TempVector
                                            AnkleNegativeWork_TempVector( RowtoFill_AnkleNegativeWork ) = AnklePowerSagittal_IndividualHopsContactPhase( AnkleAbsorptionFrames );
                                            
                                            
                                        else
                                        
                                            %This loop will actually integrate the Gth power absorption
                                            %period using trapezoidal integration. The number of loops
                                            %is one less than hte number of frames in the Gth period of
                                            %ankle power absorption. The reason for this is that the
                                            %integration uses two data points at a time - if we don't
                                            %subtract 1 from the number of data points, the last loop
                                            %will try to access a data point that doesn't exist.
                                            for h = 1 : ( length( AnkleAbsorptionFrames ) - 1 )

                                                %Perform trapezoidal integration. Formula is 0.5 * (
                                                %height * (base 1 + base 2 ) ). Height is the time step
                                                %in between data points. Base 1 is one power value,
                                                %Base 2 is the adjacent power value
                                                AnkleNegativeWork_TempVector( RowtoFill_AnkleNegativeWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( AnklePowerSagittal_IndividualHopsContactPhase( AnkleAbsorptionFrames( h )   ) +...
                                                    AnklePowerSagittal_IndividualHopsContactPhase( AnkleAbsorptionFrames( h + 1 )   )        )       );

                                                %Add 1 to RowtoFill_AnkleNegativeWork so that the next
                                                %row of AnkleNegativeWork_TempVector is filled 
                                                RowtoFill_AnkleNegativeWork = RowtoFill_AnkleNegativeWork + 1;
                                                
                                            end
                                    
                                        end
                                        
                                        %Fill in the Gth row of AnkleNegativeWork_CumSum by summing
                                        %all data points in AnkleNegativeWork_TempVector
                                        AnkleNegativeWork_CumSum( g ) = sum( AnkleNegativeWork_TempVector );
                                        
                                    end
                                        
                                        
                                        %Sum all values of AnkleNegativeWork_TempVector to get total
                                    %ankle nnegative work
                                    TotalAnkleNegativeWork_AllPeriodsAcrossContactPhase( s ) = sum( AnkleNegativeWork_CumSum );
                                    
                                    %Sum the lengths of the different periods of ankle generation,
                                    %to find total time spent in ankle generation
                                    LengthofAnkleAbsorption_Sec( s ) = sum( LengthofAnkleAbsorption_Sec_TempVector );  
                                    
                                    %Divide TotalAnkleNegativeWork by LengthofAnkleAbsorption_Sec to
                                    %obtain total ankle positive power
                                    TotalNegativePower_Ankle_EntireContactPhase(s) = TotalAnkleNegativeWork_AllPeriodsAcrossContactPhase( s ) ./ LengthofAnkleAbsorption_Sec( s );
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    %Initialize vectors to hold the total negative work for each period of ankle generation.
                                    AnklePositiveWork_CumSum = NaN( 1, 1 );
                                    LengthofAnkleGeneration_Sec_TempVector = NaN( 1, 1 );
                                    
                                    
                                    %Calculate negative work for the ankle. First, run the outer
                                    %loop once for each period of ankle absorption
                                    for g = 1 : length( BeginningofAnklePowerGeneration ) 
                                        
                                        %Create a vector containing the frames for the Gth period of
                                        %ankle power absorption
                                        AnkleGenerationFrames = BeginningofAnklePowerGeneration( g ) : EndofAnklePowerGeneration( g );
                                        
                                        %Find the length of the Gth period of ankle generation, in
                                        %seconds
                                        LengthofAnkleGeneration_Sec_TempVector( g ) = length( AnkleGenerationFrames ) ./ MoCapSampHz;
                                        
                                        %Initialize a vector to hold the individual data points for
                                        %negative work in the Gth period of ankle power absorptionn
                                        AnklePositiveWork_TempVector = NaN( 1, 1);
                                        
                                        %This will tell the H loop (below) which row of
                                        %AnklePositiveWork_TempVector to fill
                                        RowtoFill_AnklePositiveWork = 1;
                                        
                                        
                                        if length( AnkleGenerationFrames ) == 1
                                            
                                            %Fill in the Gth row of AnklePositiveWork_CumSum by summing
                                            %all data points in AnklePositiveWork_TempVector
                                            AnklePositiveWork_TempVector( RowtoFill_AnklePositiveWork ) = AnklePowerSagittal_IndividualHopsContactPhase( AnkleGenerationFrames );
                                            
                                            
                                        else
                                        
                                            %This loop will actually integrate the Gth power absorption
                                            %period using trapezoidal integration. The number of loops
                                            %is one less than hte number of frames in the Gth period of
                                            %ankle power absorption. The reason for this is that the
                                            %integration uses two data points at a time - if we don't
                                            %subtract 1 from the number of data points, the last loop
                                            %will try to access a data point that doesn't exist.
                                            for h = 1 : ( length( AnkleGenerationFrames ) - 1 )

                                                %Perform trapezoidal integration. Formula is 0.5 * (
                                                %height * (base 1 + base 2 ) ). Height is the time step
                                                %in between data points. Base 1 is one power value,
                                                %Base 2 is the adjacent power value
                                                AnklePositiveWork_TempVector( RowtoFill_AnklePositiveWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( AnklePowerSagittal_IndividualHopsContactPhase( AnkleGenerationFrames( h )   ) +...
                                                    AnklePowerSagittal_IndividualHopsContactPhase( AnkleGenerationFrames( h + 1 )   )        )       );

                                                %Add 1 to RowtoFill_AnklePositiveWork so that the next
                                                %row of AnklePositiveWork_TempVector is filled 
                                                RowtoFill_AnklePositiveWork = RowtoFill_AnklePositiveWork + 1;
                                                
                                            end
                                    
                                        end
                                        
                                        %Fill in the Gth row of AnklePositiveWork_CumSum by summing
                                        %all data points in AnklePositiveWork_TempVector
                                        AnklePositiveWork_CumSum( g ) = sum( AnklePositiveWork_TempVector );
                                        
                                    end
                                        
                                    %Sum the lengths of the different periods of ankle generation,
                                    %to find total time spent in ankle generation
                                    LengthofAnkleGeneration_Sec( s ) = sum( LengthofAnkleGeneration_Sec_TempVector );    
                                    
                                    %Sum all values of AnklePositiveWork_TempVector to get total
                                    %ankle nnegative work
                                    TotalAnklePositiveWork_AllPeriodsAcrossContactPhase( s ) = sum( AnklePositiveWork_CumSum );
                                    
                                    %Divide TotalAnklePositiveWork by LengthofAnkleGeneration_Sec to
                                    %obtain total ankle positive power
                                    TotalPositivePower_Ankle_EntireContactPhase(s) = TotalAnklePositiveWork_AllPeriodsAcrossContactPhase( s ) ./ LengthofAnkleGeneration_Sec( s );
                                    
                                    
                                            
%% Calculate Negative Work for Ankle

%                                     %Initialize vectors to hold the individual data points for
%                                     %negative and positive work. The number of data points in each
%                                     %temporary vector = 1 less than the number of positive or
%                                     %negative Frames
%                                     AnkleNegativeWork_TempVector = NaN( 1, 1);
%                                     RowtoFill_AnkleNegativeWork = 1;
%                                     
%                                     %Calculate negative work for ankle
%                                     for xa1 = 1 : ( length( AnklePowerSagittal_NegativeFrames_EntireContactPhase ) - 1 )
%                                     
%                                         %We only want to integrate adjacent data points. Example: If the
%                                         %xa1st index is data point 11 but the xa1+1st is data point
%                                         %26, don't integrate these because there is a gap betwee the
%                                         %data points.
%                                         if AnklePowerSagittal_NegativeFrames_EntireContactPhase( xa1 + 1 ) - AnklePowerSagittal_NegativeFrames_EntireContactPhase( xa1 )  == 1
%                                             
%                                             %Perform trapezoidal integration. Formula is 0.5 * (
%                                             %height * (base 1 + base 2 ) ). Height is the time step
%                                             %in between data points. Base 1 is one power value,
%                                             %Base 2 is the adjacent power value
%                                             AnkleNegativeWork_TempVector( RowtoFill_AnkleNegativeWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( AnklePowerSagittal_IndividualHopsContactPhase( AnklePowerSagittal_NegativeFrames_EntireContactPhase( xa1 )   ) +...
%                                                 AnklePowerSagittal_IndividualHopsContactPhase( AnklePowerSagittal_NegativeFrames_EntireContactPhase( xa1 + 1 )   )        )       );
%                                         
%                                             %Add 1 to RowtoFill_AnkleNegativeWork so that the next
%                                             %row of AnkleNegativeWork_TempVector is filled 
%                                             RowtoFill_AnkleNegativeWork = RowtoFill_AnkleNegativeWork + 1;
%                                             
%                                         end
%                                         
%                                     end
%                                     
%                                     %Sum all values of AnkleNegativeWork_TempVector to get total
%                                     %ankle nnegative work
%                                     TotalAnkleNegativeWork( s ) = sum( AnkleNegativeWork_TempVector );
                                    
                                    
                                    
                                    
                                    
                                    
%% Calculate Positive Work for Ankle

%                                     %Initialize vectors to hold the individual data points for
%                                     %negative and positive work. The number of data points in each
%                                     %temporary vector = 1 less than the number of positive or
%                                     %negative Frames
%                                     AnklePositiveWork_TempVector = NaN( 1, 1);
%                                     RowtoFill_AnklePositiveWork = 1;
%                                     
%                                     %Calculate negative work for ankle
%                                     for xa1 = 1 : ( length( AnklePowerSagittal_PositiveFrames_EntireContactPhase ) - 1 )
%                                     
%                                         %We only want to integrate adjacent data points. Example: If the
%                                         %xa1st index is data point 11 but the xa1+1st is data point
%                                         %26, don't integrate these because there is a gap betwee the
%                                         %data points.
%                                         if AnklePowerSagittal_PositiveFrames_EntireContactPhase( xa1 + 1 ) - AnklePowerSagittal_PositiveFrames_EntireContactPhase( xa1 )  == 1
%                                             
%                                             %Perform trapezoidal integration. Formula is 0.5 * (
%                                             %height * (base 1 + base 2 ) ). Height is the time step
%                                             %in between data points. Base 1 is one power value,
%                                             %Base 2 is the adjacent power value
%                                             AnklePositiveWork_TempVector( RowtoFill_AnklePositiveWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( AnklePowerSagittal_IndividualHopsContactPhase( AnklePowerSagittal_PositiveFrames_EntireContactPhase( xa1 )   ) +...
%                                                 AnklePowerSagittal_IndividualHopsContactPhase( AnklePowerSagittal_PositiveFrames_EntireContactPhase( xa1 + 1 )   )        )       );
%                                         
%                                             %Add 1 to RowtoFill_AnklePositiveWork so that the next
%                                             %row of AnklePositiveWork_TempVector is filled 
%                                             RowtoFill_AnklePositiveWork = RowtoFill_AnklePositiveWork + 1;
%                                             
%                                         end
%                                         
%                                     end
%                                     
%                                     %Sum all values of AnklePositiveWork_TempVector to get total
%                                     %ankle nnegative work
%                                     TotalAnklePositiveWork( s ) = sum( AnklePositiveWork_TempVector );                                    
                                    
                                    
                                    %Calculate ratio between positive and negative work
                                    if TotalAnklePositiveWork_AllPeriodsAcrossContactPhase( s ) < 0 || TotalAnkleNegativeWork_AllPeriodsAcrossContactPhase( s ) >=0
    
                                        %Calculate ratio between positive and negative work
                                        AnkleWorkRatio_EntireContactPhase( s ) =NaN;

                                    else
    
                                        %Calculate ratio between positive and negative work
                                        AnkleWorkRatio_EntireContactPhase( s ) = abs( TotalAnklePositiveWork_AllPeriodsAcrossContactPhase( s ) ./ TotalAnkleNegativeWork_AllPeriodsAcrossContactPhase( s ) );
                                    
                                    end
                                    
                                    

                                    %Total negative and positive power using entire hop cycle - not just
                                    %absorption vs generation phases - for Knee
                                    KneePowerSagittal_NegativeFrames_EntireContactPhase = find( KneePowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) < 0 );
                                    KneePowerSagittal_PositiveFrames_EntireContactPhase = find( KneePowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) > 0 );                         
                                    TotalNegativePower_Knee_EntireContactPhase(s) = sum( KneePowerSagittal_IndividualHopsContactPhase( KneePowerSagittal_NegativeFrames_EntireContactPhase ,s) );
                                    TotalPositivePower_Knee_EntireContactPhase(s) = sum( KneePowerSagittal_IndividualHopsContactPhase( KneePowerSagittal_PositiveFrames_EntireContactPhase ,s) );

                                    
                                    
                                    
                                    
                                    
%% Calculate Negative Work for Knee

%                                     %Initialize vectors to hold the individual data points for
%                                     %negative and positive work. The number of data points in each
%                                     %temporary vector = 1 less than the number of positive or
%                                     %negative Frames
%                                     KneeNegativeWork_TempVector = NaN( 1, 1);
%                                     RowtoFill_KneeNegativeWork = 1;
%                                     
%                                     %Calculate negative work for ankle
%                                     for xa1 = 1 : ( length( KneePowerSagittal_NegativeFrames_EntireContactPhase ) - 1 )
%                                     
%                                         %We only want to integrate adjacent data points. Example: If the
%                                         %xa1st index is data point 11 but the xa1+1st is data point
%                                         %26, don't integrate these because there is a gap betwee the
%                                         %data points.
%                                         if KneePowerSagittal_NegativeFrames_EntireContactPhase( xa1 + 1 ) - KneePowerSagittal_NegativeFrames_EntireContactPhase( xa1 )  == 1
%                                             
%                                             %Perform trapezoidal integration. Formula is 0.5 * (
%                                             %height * (base 1 + base 2 ) ). Height is the time step
%                                             %in between data points. Base 1 is one power value,
%                                             %Base 2 is the adjacent power value
%                                             KneeNegativeWork_TempVector( RowtoFill_KneeNegativeWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( KneePowerSagittal_IndividualHopsContactPhase( KneePowerSagittal_NegativeFrames_EntireContactPhase( xa1 )   ) +...
%                                                 KneePowerSagittal_IndividualHopsContactPhase( KneePowerSagittal_NegativeFrames_EntireContactPhase( xa1 + 1 )   )        )       );
%                                         
%                                             %Add 1 to RowtoFill_KneeNegativeWork so that the next
%                                             %row of KneeNegativeWork_TempVector is filled 
%                                             RowtoFill_KneeNegativeWork = RowtoFill_KneeNegativeWork + 1;
%                                             
%                                         end
%                                         
%                                     end
%                                     
%                                     %Sum all values of KneeNegativeWork_TempVector to get total
%                                     %ankle nnegative work
%                                     TotalKneeNegativeWork( s ) = sum( KneeNegativeWork_TempVector );


%% FIND All  Periods of Positive/Negative Work - KNEE                                    
                                    
                                    %Initialize variables to hold the beginning and end of each
                                    %period of ankle power absorption and generation
                                    BeginningofKneePowerGeneration = NaN( 1, 1);
                                    BeginningofKneePowerAbsorption = NaN( 1, 1);
                                    EndofKneePowerGeneration = NaN( 1, 1);
                                    EndofKneePowerAbsorption = NaN( 1, 1);
                                    
                                    %Will use this when finding the first frame of all periods of ankle
                                    %power generation - this will fill in the next element of BeginningofKneePowerGeneration
                                    RowtoFill_BeginKneePowerGeneration = 1;
                                    RowtoFill_BeginKneePowerAbsorption = 1;
                                    RowtoFill_EndKneePowerGeneration = 1;
                                    RowtoFill_EndKneePowerAbsorption = 1;
                                    
                                    %Find and integrate all periods of positive and negative work. There may be
                                    %multiple periods of positive work and multiple periods of
                                    %negative work - will find integrate each period separately then
                                    %add all together to find total positive work and total negative
                                    %work.
                                    
                                    %In this next line, we are subtracting 1 from the number of
                                    %elements in the Sth hop, because the embedded If statement will
                                    %use the f and f+1st values. If we don't subtract 1, the final
                                    %loop will try to access an element that doesn't exist.
                                    for f = 1 : (NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) - 1)
                                    
                                        if f == 1
%                                             %If the first element in
%                                             %KneePowerSagittal_IndividualHopsContactPhase is negative,
%                                             %this is the beginning of a period of power absorption
%                                             if KneePowerSagittal_IndividualHopsContactPhase( f, s ) < 0
% 
%                                                 BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = 1;
% 
%                                                 RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;
% 
% 
%                                             %If the first element in
%                                             %KneePowerSagittal_IndividualHopsContactPhase is positive,
%                                             %this is the beginning of a period of power generation    
%                                             elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) > 0
% 
%                                                 BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = 1;
% 
%                                                 RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;



                                            if KneePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                                
                                                BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = 1;

                                                RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;
                                                
                                                
                                                
                                                
                                                BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = f + 1;

                                                RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;


                                                
                                                EndofKneePowerGeneration( RowtoFill_EndKneePowerGeneration ) = f;

                                                RowtoFill_EndKneePowerGeneration = RowtoFill_EndKneePowerGeneration + 1;

                                                
                                                

                                            elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) == 0

                                                
                                                BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = 1;

                                                RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;
                                                
                                                
                                                
                                                EndofKneePowerGeneration( RowtoFill_EndKneePowerGeneration ) = f;

                                                RowtoFill_EndKneePowerGeneration = RowtoFill_EndKneePowerGeneration + 1;     

                                                
                                                
                                                

                                           elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                               
                                               BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = 1;

                                                RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;
                                               
                                               
                                                
                                                BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = f + 1;

                                                RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;


                                                 EndofKneePowerAbsorption( RowtoFill_EndKneePowerAbsorption ) = f;

                                                RowtoFill_EndKneePowerAbsorption = RowtoFill_EndKneePowerAbsorption + 1;

                                                
                                                
                                                
                                                
                                             elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) == 0

                                               
                                               BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = 1;

                                                RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;
                                               
                                               


                                                 EndofKneePowerAbsorption( RowtoFill_EndKneePowerAbsorption ) = f;

                                                RowtoFill_EndKneePowerAbsorption = RowtoFill_EndKneePowerAbsorption + 1;   
                                                

                                                
                                                

                                             elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                                BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = f + 1;

                                                RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;   



                                                

                                            elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                                BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = f + 1;

                                                RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;
                                                
                                                
                                                
                                                
                                            elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                               
                                               BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = 1;

                                                RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;
                                                
                                                
                                                
                                            elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && KneePowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                                
                                                BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = 1;

                                                RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;
                                                
                                                
                                            end
                                            
                                            
                                            
                                            
                                            
                                        
                                        
                                        elseif f~=1 
                                            
                                            if KneePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && KneePowerSagittal_IndividualHopsContactPhase( f+1, s ) > 0

                                                    BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = f + 1;

                                                    RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;


                                                    EndofKneePowerAbsorption( RowtoFill_EndKneePowerAbsorption ) = f;

                                                    RowtoFill_EndKneePowerAbsorption = RowtoFill_EndKneePowerAbsorption + 1;


                                                %If Element F in
                                                %KneePowerSagittal_IndividualHopsContactPhase is greater than
                                                %or equal to 0 AND Element F+1 is less than 0, Element
                                                %F+1 marks the beginning of a period of power absorption.   
                                                %In turn, Element F markes the end of a period of power
                                                %generation
                                                elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && KneePowerSagittal_IndividualHopsContactPhase( f+1, s ) < 0


                                                    BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = f + 1;

                                                    RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;



                                                    EndofKneePowerGeneration( RowtoFill_EndKneePowerGeneration ) = f;

                                                    RowtoFill_EndKneePowerGeneration = RowtoFill_EndKneePowerGeneration + 1;



                                               %If Element F in
                                                %KneePowerSagittal_IndividualHopsContactPhase equals
                                                % 0 AND Element F+1 is greater than 0, Element
                                                %F+1 marks the beginning of a period of power generation.
                                                %Element F DOES NOT mark the end of power absorption, since
                                                %power absorption must end before power becomes 0
                                                elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && KneePowerSagittal_IndividualHopsContactPhase( f+1, s ) > 0

                                                    BeginningofKneePowerGeneration( RowtoFill_BeginKneePowerGeneration ) = f + 1;

                                                    RowtoFill_BeginKneePowerGeneration = RowtoFill_BeginKneePowerGeneration + 1;



                                                %If Element F in
                                                %KneePowerSagittal_IndividualHopsContactPhase is equal to 0 AND Element F+1 is less than 0, Element
                                                %F+1 marks the beginning of a period of power absorption.    
                                                %Element F DOES NOT mark the end of power generation, since
                                                %power generation must end before power becomes 0
                                                elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && KneePowerSagittal_IndividualHopsContactPhase( f+1, s ) < 0


                                                    BeginningofKneePowerAbsorption( RowtoFill_BeginKneePowerAbsorption ) = f + 1;

                                                    RowtoFill_BeginKneePowerAbsorption = RowtoFill_BeginKneePowerAbsorption + 1;



                                                %If Element F in
                                                %KneePowerSagittal_IndividualHopsContactPhase is less than
                                                %0 AND Element F+1 equals 0, Element
                                                %F marks the end of a period of power absorption.    
                                                elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && KneePowerSagittal_IndividualHopsContactPhase( f+1, s ) == 0


                                                    EndofKneePowerAbsorption( RowtoFill_EndKneePowerAbsorption ) = f;

                                                    RowtoFill_EndKneePowerAbsorption = RowtoFill_EndKneePowerAbsorption + 1;


                                                %If Element F in
                                                %KneePowerSagittal_IndividualHopsContactPhase is greater than
                                                %0 AND Element F+1 equals 0, Element
                                                %F marks the end of a period of power generation.    
                                                elseif KneePowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && KneePowerSagittal_IndividualHopsContactPhase( f+1, s ) == 0

                                                    EndofKneePowerGeneration( RowtoFill_EndKneePowerGeneration ) = f;

                                                    RowtoFill_EndKneePowerGeneration = RowtoFill_EndKneePowerGeneration + 1;

                                            end

                                            %If f = the second to last element in the hip power time
                                            %series, execute this code
                                            if f == NumEl_SthHopContactPhase_MoCapSamplingHz(s,q)-1


                                                %If the last element of
                                                %KneePowerSagittal_IndividualHopsContactPhase is positive,
                                                %the last element marks the end of a period of power
                                                %generation
                                                if KneePowerSagittal_IndividualHopsContactPhase( NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) > 0

                                                    EndofKneePowerGeneration( RowtoFill_EndKneePowerGeneration ) = NumEl_SthHopContactPhase_MoCapSamplingHz(s,q);



                                                %If the last element of
                                                %KneePowerSagittal_IndividualHopsContactPhase is negative,
                                                %the last element marks the end of a period of power
                                                %absorption   
                                                elseif  KneePowerSagittal_IndividualHopsContactPhase( NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) < 0

                                                    EndofKneePowerAbsorption( RowtoFill_EndKneePowerAbsorption ) = NumEl_SthHopContactPhase_MoCapSamplingHz(s,q);
                                                    
                                                end
                                                
                                            end
                                            
                                        end
                                        
                                    end
                                            
                                            
                                   
                                    
                                    %Initialize vectors to hold the total negative work for each period of ankle absorption.
                                    KneeNegativeWork_CumSum = NaN( 1, 1 );
                                    LengthofKneeAbsorption_Sec_TempVector = NaN( 1, 1 );
                                    
                                    
                                    %Calculate negative work for the ankle. First, run the outer
                                    %loop once for each period of ankle absorption
                                    for g = 1 : length( BeginningofKneePowerAbsorption ) 
                                        
                                        %Create a vector containing the frames for the Gth period of
                                        %ankle power absorption
                                        KneeAbsorptionFrames = BeginningofKneePowerAbsorption( g ) : EndofKneePowerAbsorption( g );
                                        
                                        %Find the length of the Gth period of ankle absorption, in
                                        %seconds
                                        LengthofKneeAbsorption_Sec_TempVector( g ) = length( KneeAbsorptionFrames ) ./ MoCapSampHz;
                                        
                                        %Initialize a vector to hold the individual data points for
                                        %negative work in the Gth period of ankle power absorptionn
                                        KneeNegativeWork_TempVector = NaN( 1, 1);
                                        
                                        %This will tell the H loop (below) which row of
                                        %KneeNegativeWork_TempVector to fill
                                        RowtoFill_KneeNegativeWork = 1;
                                        
                                        
                                        if length( KneeAbsorptionFrames ) == 1
                                            
                                            %Fill in the Gth row of KneeNegativeWork_CumSum by summing
                                            %all data points in KneeNegativeWork_TempVector
                                            KneeNegativeWork_TempVector( RowtoFill_KneeNegativeWork ) = KneePowerSagittal_IndividualHopsContactPhase( KneeAbsorptionFrames );
                                            
                                            
                                        else
                                        
                                            %This loop will actually integrate the Gth power absorption
                                            %period using trapezoidal integration. The number of loops
                                            %is one less than hte number of frames in the Gth period of
                                            %ankle power absorption. The reason for this is that the
                                            %integration uses two data points at a time - if we don't
                                            %subtract 1 from the number of data points, the last loop
                                            %will try to access a data point that doesn't exist.
                                            for h = 1 : ( length( KneeAbsorptionFrames ) - 1 )

                                                %Perform trapezoidal integration. Formula is 0.5 * (
                                                %height * (base 1 + base 2 ) ). Height is the time step
                                                %in between data points. Base 1 is one power value,
                                                %Base 2 is the adjacent power value
                                                KneeNegativeWork_TempVector( RowtoFill_KneeNegativeWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( KneePowerSagittal_IndividualHopsContactPhase( KneeAbsorptionFrames( h )   ) +...
                                                    KneePowerSagittal_IndividualHopsContactPhase( KneeAbsorptionFrames( h + 1 )   )        )       );

                                                %Add 1 to RowtoFill_KneeNegativeWork so that the next
                                                %row of KneeNegativeWork_TempVector is filled 
                                                RowtoFill_KneeNegativeWork = RowtoFill_KneeNegativeWork + 1;
                                                
                                            end
                                    
                                        end
                                        
                                        %Fill in the Gth row of KneeNegativeWork_CumSum by summing
                                        %all data points in KneeNegativeWork_TempVector
                                        KneeNegativeWork_CumSum( g ) = sum( KneeNegativeWork_TempVector );
                                        
                                    end
                                        
                                        
                                        %Sum all values of KneeNegativeWork_TempVector to get total
                                    %ankle nnegative work
                                    TotalKneeNegativeWork_AllPeriodsAcrossContactPhase( s ) = sum( KneeNegativeWork_CumSum );
                                    
                                    %Sum the lengths of the different periods of ankle generation,
                                    %to find total time spent in ankle generation
                                    LengthofKneeAbsorption_Sec( s ) = sum( LengthofKneeAbsorption_Sec_TempVector );  
                                    
                                    %Divide TotalKneeNegativeWork by LengthofKneeAbsorption_Sec to
                                    %obtain total ankle positive power
                                    TotalNegativePower_Knee_EntireContactPhase(s) = TotalKneeNegativeWork_AllPeriodsAcrossContactPhase( s ) ./ LengthofKneeAbsorption_Sec( s );
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    %Initialize vectors to hold the total negative work for each period of ankle generation.
                                    KneePositiveWork_CumSum = NaN( 1, 1 );
                                    LengthofKneeGeneration_Sec_TempVector = NaN( 1, 1 );
                                    
                                    
                                    %Calculate negative work for the ankle. First, run the outer
                                    %loop once for each period of ankle absorption
                                    for g = 1 : length( BeginningofKneePowerGeneration ) 
                                        
                                        %Create a vector containing the frames for the Gth period of
                                        %ankle power absorption
                                        KneeGenerationFrames = BeginningofKneePowerGeneration( g ) : EndofKneePowerGeneration( g );
                                        
                                        %Find the length of the Gth period of ankle generation, in
                                        %seconds
                                        LengthofKneeGeneration_Sec_TempVector( g ) = length( KneeGenerationFrames ) ./ MoCapSampHz;
                                        
                                        %Initialize a vector to hold the individual data points for
                                        %negative work in the Gth period of ankle power absorptionn
                                        KneePositiveWork_TempVector = NaN( 1, 1);
                                        
                                        %This will tell the H loop (below) which row of
                                        %KneePositiveWork_TempVector to fill
                                        RowtoFill_KneePositiveWork = 1;
                                        
                                        
                                        if length( KneeGenerationFrames ) == 1
                                            
                                            %Fill in the Gth row of KneePositiveWork_CumSum by summing
                                            %all data points in KneePositiveWork_TempVector
                                            KneePositiveWork_TempVector( RowtoFill_KneePositiveWork ) = KneePowerSagittal_IndividualHopsContactPhase( KneeGenerationFrames );
                                            
                                            
                                        else
                                        
                                            %This loop will actually integrate the Gth power absorption
                                            %period using trapezoidal integration. The number of loops
                                            %is one less than hte number of frames in the Gth period of
                                            %ankle power absorption. The reason for this is that the
                                            %integration uses two data points at a time - if we don't
                                            %subtract 1 from the number of data points, the last loop
                                            %will try to access a data point that doesn't exist.
                                            for h = 1 : ( length( KneeGenerationFrames ) - 1 )

                                                %Perform trapezoidal integration. Formula is 0.5 * (
                                                %height * (base 1 + base 2 ) ). Height is the time step
                                                %in between data points. Base 1 is one power value,
                                                %Base 2 is the adjacent power value
                                                KneePositiveWork_TempVector( RowtoFill_KneePositiveWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( KneePowerSagittal_IndividualHopsContactPhase( KneeGenerationFrames( h )   ) +...
                                                    KneePowerSagittal_IndividualHopsContactPhase( KneeGenerationFrames( h + 1 )   )        )       );

                                                %Add 1 to RowtoFill_KneePositiveWork so that the next
                                                %row of KneePositiveWork_TempVector is filled 
                                                RowtoFill_KneePositiveWork = RowtoFill_KneePositiveWork + 1;
                                                
                                            end
                                    
                                        end
                                        
                                        %Fill in the Gth row of KneePositiveWork_CumSum by summing
                                        %all data points in KneePositiveWork_TempVector
                                        KneePositiveWork_CumSum( g ) = sum( KneePositiveWork_TempVector );
                                        
                                    end
                                        
                                    %Sum the lengths of the different periods of ankle generation,
                                    %to find total time spent in ankle generation
                                    LengthofKneeGeneration_Sec( s ) = sum( LengthofKneeGeneration_Sec_TempVector );    
                                    
                                    %Sum all values of KneePositiveWork_TempVector to get total
                                    %ankle nnegative work
                                    TotalKneePositiveWork_AllPeriodsAcrossContactPhase( s ) = sum( KneePositiveWork_CumSum );
                                    
                                    %Divide TotalKneePositiveWork by LengthofKneeGeneration_Sec to
                                    %obtain total ankle positive power
                                    TotalPositivePower_Knee_EntireContactPhase(s) = TotalKneePositiveWork_AllPeriodsAcrossContactPhase( s ) ./ LengthofKneeGeneration_Sec( s );
                                    
                                    
                                    
%% Calculate Positive Work for Knee

%                                     %Initialize vectors to hold the individual data points for
%                                     %negative and positive work. The number of data points in each
%                                     %temporary vector = 1 less than the number of positive or
%                                     %negative Frames
%                                     KneePositiveWork_TempVector = NaN( 1, 1);
%                                     RowtoFill_KneePositiveWork = 1;
%                                     
%                                     %Calculate negative work for ankle
%                                     for xa1 = 1 : ( length( KneePowerSagittal_PositiveFrames_EntireContactPhase ) - 1 )
%                                     
%                                         %We only want to integrate adjacent data points. Example: If the
%                                         %xa1st index is data point 11 but the xa1+1st is data point
%                                         %26, don't integrate these because there is a gap betwee the
%                                         %data points.
%                                         if KneePowerSagittal_PositiveFrames_EntireContactPhase( xa1 + 1 ) - KneePowerSagittal_PositiveFrames_EntireContactPhase( xa1 )  == 1
%                                             
%                                             %Perform trapezoidal integration. Formula is 0.5 * (
%                                             %height * (base 1 + base 2 ) ). Height is the time step
%                                             %in between data points. Base 1 is one power value,
%                                             %Base 2 is the adjacent power value
%                                             KneePositiveWork_TempVector( RowtoFill_KneePositiveWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( KneePowerSagittal_IndividualHopsContactPhase( KneePowerSagittal_PositiveFrames_EntireContactPhase( xa1 )   ) +...
%                                                 KneePowerSagittal_IndividualHopsContactPhase( KneePowerSagittal_PositiveFrames_EntireContactPhase( xa1 + 1 )   )        )       );
%                                         
%                                             %Add 1 to RowtoFill_KneePositiveWork so that the next
%                                             %row of KneePositiveWork_TempVector is filled 
%                                             RowtoFill_KneePositiveWork = RowtoFill_KneePositiveWork + 1;
%                                             
%                                         end
%                                         
%                                     end
%                                     
%                                     %Sum all values of KneePositiveWork_TempVector to get total
%                                     %ankle nnegative work
%                                     TotalKneePositiveWork( s ) = sum( KneePositiveWork_TempVector );                                            
                                    
                                    
                                    
                                    %Calculate ratio between positive and negative work
                                    if TotalKneePositiveWork_AllPeriodsAcrossContactPhase( s ) < 0 || TotalKneeNegativeWork_AllPeriodsAcrossContactPhase( s ) >=0
    
                                        %Calculate ratio between positive and negative work
                                        KneeWorkRatio_EntireContactPhase( s ) = NaN;

                                    else
    
                                        %Calculate ratio between positive and negative work
                                        KneeWorkRatio_EntireContactPhase( s ) = abs( TotalKneePositiveWork_AllPeriodsAcrossContactPhase( s ) ./ TotalKneeNegativeWork_AllPeriodsAcrossContactPhase( s ) );
                                    
                                    end
                                    
                                    
                                    
                                    
                                    
                                    %Total negative and positive power using entire hop cycle - not just
                                    %absorption vs generation phases - for Hip
                                    HipPowerSagittal_NegativeFrames_EntireContactPhase = find( HipPowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) < 0 );
                                    HipPowerSagittal_PositiveFrames_EntireContactPhase = find( HipPowerSagittal_IndividualHopsContactPhase(1:NumEl_SthHopContactPhase_MoCapSamplingHz(s,q),s) > 0 );                         
                                    TotalNegativePower_Hip_EntireContactPhase(s) = sum( HipPowerSagittal_IndividualHopsContactPhase( HipPowerSagittal_NegativeFrames_EntireContactPhase ,s) );
                                    TotalPositivePower_Hip_EntireContactPhase(s) = sum( HipPowerSagittal_IndividualHopsContactPhase( HipPowerSagittal_PositiveFrames_EntireContactPhase ,s) );

                                    
                                    
                                    
%% Calculate Negative Work for Hip

%                                     %Initialize vectors to hold the individual data points for
%                                     %negative and positive work. The number of data points in each
%                                     %temporary vector = 1 less than the number of positive or
%                                     %negative Frames
%                                     HipNegativeWork_TempVector = NaN( 1, 1);
%                                     RowtoFill_HipNegativeWork = 1;
%                                     
%                                     %Calculate negative work for ankle
%                                     for xa1 = 1 : ( length( HipPowerSagittal_NegativeFrames_EntireContactPhase ) - 1 )
%                                     
%                                         %We only want to integrate adjacent data points. Example: If the
%                                         %xa1st index is data point 11 but the xa1+1st is data point
%                                         %26, don't integrate these because there is a gap betwee the
%                                         %data points.
%                                         if HipPowerSagittal_NegativeFrames_EntireContactPhase( xa1 + 1 ) - HipPowerSagittal_NegativeFrames_EntireContactPhase( xa1 )  == 1
%                                             
%                                             %Perform trapezoidal integration. Formula is 0.5 * (
%                                             %height * (base 1 + base 2 ) ). Height is the time step
%                                             %in between data points. Base 1 is one power value,
%                                             %Base 2 is the adjacent power value
%                                             HipNegativeWork_TempVector( RowtoFill_HipNegativeWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( HipPowerSagittal_IndividualHopsContactPhase( HipPowerSagittal_NegativeFrames_EntireContactPhase( xa1 )   ) +...
%                                                 HipPowerSagittal_IndividualHopsContactPhase( HipPowerSagittal_NegativeFrames_EntireContactPhase( xa1 + 1 )   )        )       );
%                                         
%                                             %Add 1 to RowtoFill_HipNegativeWork so that the next
%                                             %row of HipNegativeWork_TempVector is filled 
%                                             RowtoFill_HipNegativeWork = RowtoFill_HipNegativeWork + 1;
%                                             
%                                         end
%                                         
%                                     end
%                                     
%                                     %Sum all values of HipNegativeWork_TempVector to get total
%                                     %ankle nnegative work
%                                     TotalHipNegativeWork( s ) = sum( HipNegativeWork_TempVector );
                                    
                                    




%% FIND All  Periods of Positive/Negative Work - Hip

                                    %Initialize variables to hold the beginning and end of each
                                    %period of ankle power absorption and generation
                                    BeginningofHipPowerGeneration = NaN( 1, 1);
                                    BeginningofHipPowerAbsorption = NaN( 1, 1);
                                    EndofHipPowerGeneration = NaN( 1, 1);
                                    EndofHipPowerAbsorption = NaN( 1, 1);
                                    
                                    %Will use this when finding the first frame of all periods of ankle
                                    %power generation - this will fill in the next element of BeginningofHipPowerGeneration
                                    RowtoFill_BeginHipPowerGeneration = 1;
                                    RowtoFill_BeginHipPowerAbsorption = 1;
                                    RowtoFill_EndHipPowerGeneration = 1;
                                    RowtoFill_EndHipPowerAbsorption = 1;
                                    
                                    %Find and integrate all periods of positive and negative work. There may be
                                    %multiple periods of positive work and multiple periods of
                                    %negative work - will find integrate each period separately then
                                    %add all together to find total positive work and total negative
                                    %work.
                                    
                                    %In this next line, we are subtracting 1 from the number of
                                    %elements in the Sth hop, because the embedded If statement will
                                    %use the f and f+1st values. If we don't subtract 1, the final
                                    %loop will try to access an element that doesn't exist.
                                    for f = 1 : (NumEl_SthHopContactPhase_MoCapSamplingHz(s,q) - 1)
                                    
                                        if f == 1
%                                             %If the first element in
%                                             %HipPowerSagittal_IndividualHopsContactPhase is negative,
%                                             %this is the beginning of a period of power absorption
%                                             if HipPowerSagittal_IndividualHopsContactPhase( f, s ) < 0
% 
%                                                 BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = 1;
% 
%                                                 RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;
% 
% 
%                                             %If the first element in
%                                             %HipPowerSagittal_IndividualHopsContactPhase is positive,
%                                             %this is the beginning of a period of power generation    
%                                             elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) > 0
% 
%                                                 BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = 1;
% 
%                                                 RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;



                                            if HipPowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                                
                                                BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = 1;

                                                RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;
                                                
                                                
                                                
                                                
                                                BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = f + 1;

                                                RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;


                                                
                                                EndofHipPowerGeneration( RowtoFill_EndHipPowerGeneration ) = f;

                                                RowtoFill_EndHipPowerGeneration = RowtoFill_EndHipPowerGeneration + 1;

                                                
                                                

                                            elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) == 0

                                                
                                                BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = 1;

                                                RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;
                                                
                                                
                                                
                                                EndofHipPowerGeneration( RowtoFill_EndHipPowerGeneration ) = f;

                                                RowtoFill_EndHipPowerGeneration = RowtoFill_EndHipPowerGeneration + 1;     

                                                
                                                
                                                

                                           elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                               
                                               BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = 1;

                                                RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;
                                               
                                               
                                                
                                                BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = f + 1;

                                                RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;


                                                 EndofHipPowerAbsorption( RowtoFill_EndHipPowerAbsorption ) = f;

                                                RowtoFill_EndHipPowerAbsorption = RowtoFill_EndHipPowerAbsorption + 1;

                                                
                                                
                                                
                                                
                                             elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) == 0

                                               
                                               BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = 1;

                                                RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;
                                               
                                               


                                                 EndofHipPowerAbsorption( RowtoFill_EndHipPowerAbsorption ) = f;

                                                RowtoFill_EndHipPowerAbsorption = RowtoFill_EndHipPowerAbsorption + 1;   
                                                

                                                
                                                

                                             elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                                BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = f + 1;

                                                RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;   



                                                

                                            elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                                BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = f + 1;

                                                RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;
                                                
                                                
                                                
                                            elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) < 0

                                               
                                               BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = 1;

                                                RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;
                                                
                                                
                                                
                                            elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && HipPowerSagittal_IndividualHopsContactPhase( f + 1, s ) > 0

                                                
                                                BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = 1;

                                                RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;
                                                
                                                
                                            end
                                            
                                            

                                            
                                        
                                        
                                        elseif f~=1 
                                            
                                            if HipPowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && HipPowerSagittal_IndividualHopsContactPhase( f+1, s ) > 0

                                                    BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = f + 1;

                                                    RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;


                                                    EndofHipPowerAbsorption( RowtoFill_EndHipPowerAbsorption ) = f;

                                                    RowtoFill_EndHipPowerAbsorption = RowtoFill_EndHipPowerAbsorption + 1;


                                                %If Element F in
                                                %HipPowerSagittal_IndividualHopsContactPhase is greater than
                                                %or equal to 0 AND Element F+1 is less than 0, Element
                                                %F+1 marks the beginning of a period of power absorption.   
                                                %In turn, Element F markes the end of a period of power
                                                %generation
                                                elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && HipPowerSagittal_IndividualHopsContactPhase( f+1, s ) < 0


                                                    BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = f + 1;

                                                    RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;



                                                    EndofHipPowerGeneration( RowtoFill_EndHipPowerGeneration ) = f;

                                                    RowtoFill_EndHipPowerGeneration = RowtoFill_EndHipPowerGeneration + 1;



                                               %If Element F in
                                                %HipPowerSagittal_IndividualHopsContactPhase equals
                                                % 0 AND Element F+1 is greater than 0, Element
                                                %F+1 marks the beginning of a period of power generation.
                                                %Element F DOES NOT mark the end of power absorption, since
                                                %power absorption must end before power becomes 0
                                                elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && HipPowerSagittal_IndividualHopsContactPhase( f+1, s ) > 0

                                                    BeginningofHipPowerGeneration( RowtoFill_BeginHipPowerGeneration ) = f + 1;

                                                    RowtoFill_BeginHipPowerGeneration = RowtoFill_BeginHipPowerGeneration + 1;



                                                %If Element F in
                                                %HipPowerSagittal_IndividualHopsContactPhase is equal to 0 AND Element F+1 is less than 0, Element
                                                %F+1 marks the beginning of a period of power absorption.    
                                                %Element F DOES NOT mark the end of power generation, since
                                                %power generation must end before power becomes 0
                                                elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) == 0 && HipPowerSagittal_IndividualHopsContactPhase( f+1, s ) < 0


                                                    BeginningofHipPowerAbsorption( RowtoFill_BeginHipPowerAbsorption ) = f + 1;

                                                    RowtoFill_BeginHipPowerAbsorption = RowtoFill_BeginHipPowerAbsorption + 1;



                                                %If Element F in
                                                %HipPowerSagittal_IndividualHopsContactPhase is less than
                                                %0 AND Element F+1 equals 0, Element
                                                %F marks the end of a period of power absorption.    
                                                elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) < 0 && HipPowerSagittal_IndividualHopsContactPhase( f+1, s ) == 0


                                                    EndofHipPowerAbsorption( RowtoFill_EndHipPowerAbsorption ) = f;

                                                    RowtoFill_EndHipPowerAbsorption = RowtoFill_EndHipPowerAbsorption + 1;


                                                %If Element F in
                                                %HipPowerSagittal_IndividualHopsContactPhase is greater than
                                                %0 AND Element F+1 equals 0, Element
                                                %F marks the end of a period of power generation.    
                                                elseif HipPowerSagittal_IndividualHopsContactPhase( f, s ) > 0 && HipPowerSagittal_IndividualHopsContactPhase( f+1, s ) == 0

                                                    EndofHipPowerGeneration( RowtoFill_EndHipPowerGeneration ) = f;

                                                    RowtoFill_EndHipPowerGeneration = RowtoFill_EndHipPowerGeneration + 1;
                                                    
                                            end
                                            
                                            
                                            
                                            %If f = the second to last element in the hip power time
                                            %series, execute this code
                                            if f == NumEl_SthHopContactPhase_MoCapSamplingHz(s,q)-1


                                                %If the last element of
                                                %HipPowerSagittal_IndividualHopsContactPhase is positive,
                                                %the last element marks the end of a period of power
                                                %generation
                                                if HipPowerSagittal_IndividualHopsContactPhase( NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) > 0

                                                    EndofHipPowerGeneration( RowtoFill_EndHipPowerGeneration ) = NumEl_SthHopContactPhase_MoCapSamplingHz(s,q);



                                                %If the last element of
                                                %HipPowerSagittal_IndividualHopsContactPhase is negative,
                                                %the last element marks the end of a period of power
                                                %absorption   
                                                elseif  HipPowerSagittal_IndividualHopsContactPhase( NumEl_SthHopContactPhase_MoCapSamplingHz(s,q), s ) < 0

                                                    EndofHipPowerAbsorption( RowtoFill_EndHipPowerAbsorption ) = NumEl_SthHopContactPhase_MoCapSamplingHz(s,q);
                                                    
                                                end
                                                
                                            end
                                            
                                        end
                                        
                                    end
                                            
                                    
                                    
                                   
                                    
                                    %Initialize vectors to hold the total negative work for each period of ankle absorption.
                                    HipNegativeWork_CumSum = NaN( 1, 1 );
                                    LengthofHipAbsorption_Sec_TempVector = NaN( 1, 1 );
                                    
                                    
                                    %Calculate negative work for the ankle. First, run the outer
                                    %loop once for each period of ankle absorption
                                    for g = 1 : length( BeginningofHipPowerAbsorption ) 
                                        
                                        %Create a vector containing the frames for the Gth period of
                                        %ankle power absorption
                                        HipAbsorptionFrames = BeginningofHipPowerAbsorption( g ) : EndofHipPowerAbsorption( g );
                                        
                                        %Find the length of the Gth period of ankle absorption, in
                                        %seconds
                                        LengthofHipAbsorption_Sec_TempVector( g ) = length( HipAbsorptionFrames ) ./ MoCapSampHz;
                                        
                                        %Initialize a vector to hold the individual data points for
                                        %negative work in the Gth period of ankle power absorptionn
                                        HipNegativeWork_TempVector = NaN( 1, 1);
                                        
                                        %This will tell the H loop (below) which row of
                                        %HipNegativeWork_TempVector to fill
                                        RowtoFill_HipNegativeWork = 1;
                                        
                                        
                                        if length( HipAbsorptionFrames ) == 1
                                            
                                            %Fill in the Gth row of HipNegativeWork_CumSum by summing
                                            %all data points in HipNegativeWork_TempVector
                                            HipNegativeWork_TempVector( RowtoFill_HipNegativeWork ) = HipPowerSagittal_IndividualHopsContactPhase( HipAbsorptionFrames );
                                            
                                            
                                        else
                                        
                                            %This loop will actually integrate the Gth power absorption
                                            %period using trapezoidal integration. The number of loops
                                            %is one less than hte number of frames in the Gth period of
                                            %ankle power absorption. The reason for this is that the
                                            %integration uses two data points at a time - if we don't
                                            %subtract 1 from the number of data points, the last loop
                                            %will try to access a data point that doesn't exist.
                                            for h = 1 : ( length( HipAbsorptionFrames ) - 1 )

                                                %Perform trapezoidal integration. Formula is 0.5 * (
                                                %height * (base 1 + base 2 ) ). Height is the time step
                                                %in between data points. Base 1 is one power value,
                                                %Base 2 is the adjacent power value
                                                HipNegativeWork_TempVector( RowtoFill_HipNegativeWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( HipPowerSagittal_IndividualHopsContactPhase( HipAbsorptionFrames( h )   ) +...
                                                    HipPowerSagittal_IndividualHopsContactPhase( HipAbsorptionFrames( h + 1 )   )        )       );

                                                %Add 1 to RowtoFill_HipNegativeWork so that the next
                                                %row of HipNegativeWork_TempVector is filled 
                                                RowtoFill_HipNegativeWork = RowtoFill_HipNegativeWork + 1;
                                                
                                            end
                                    
                                        end
                                        
                                        %Fill in the Gth row of HipNegativeWork_CumSum by summing
                                        %all data points in HipNegativeWork_TempVector
                                        HipNegativeWork_CumSum( g ) = sum( HipNegativeWork_TempVector );
                                        
                                    end
                                        
                                        
                                        %Sum all values of HipNegativeWork_TempVector to get total
                                    %ankle nnegative work
                                    TotalHipNegativeWork_AllPeriodsAcrossContactPhase( s ) = sum( HipNegativeWork_CumSum );
                                    
                                    %Sum the lengths of the different periods of ankle generation,
                                    %to find total time spent in ankle generation
                                    LengthofHipAbsorption_Sec( s ) = sum( LengthofHipAbsorption_Sec_TempVector );  
                                    
                                    %Divide TotalHipNegativeWork by LengthofHipAbsorption_Sec to
                                    %obtain total ankle positive power
                                    TotalNegativePower_Hip_EntireContactPhase(s) = TotalHipNegativeWork_AllPeriodsAcrossContactPhase( s ) ./ LengthofHipAbsorption_Sec( s );
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    %Initialize vectors to hold the total negative work for each period of ankle generation.
                                    HipPositiveWork_CumSum = NaN( 1, 1 );
                                    LengthofHipGeneration_Sec_TempVector = NaN( 1, 1 );
                                    
                                    
                                    %Calculate negative work for the ankle. First, run the outer
                                    %loop once for each period of ankle absorption
                                    for g = 1 : length( BeginningofHipPowerGeneration ) 
                                        
                                        %Create a vector containing the frames for the Gth period of
                                        %ankle power absorption
                                        HipGenerationFrames = BeginningofHipPowerGeneration( g ) : EndofHipPowerGeneration( g );
                                        
                                        %Find the length of the Gth period of ankle generation, in
                                        %seconds
                                        LengthofHipGeneration_Sec_TempVector( g ) = length( HipGenerationFrames ) ./ MoCapSampHz;
                                        
                                        %Initialize a vector to hold the individual data points for
                                        %negative work in the Gth period of ankle power absorptionn
                                        HipPositiveWork_TempVector = NaN( 1, 1);
                                        
                                        %This will tell the H loop (below) which row of
                                        %HipPositiveWork_TempVector to fill
                                        RowtoFill_HipPositiveWork = 1;
                                        
                                        
                                        if length( HipGenerationFrames ) == 1
                                            
                                            %Fill in the Gth row of HipPositiveWork_CumSum by summing
                                            %all data points in HipPositiveWork_TempVector
                                            HipPositiveWork_TempVector( RowtoFill_HipPositiveWork ) = HipPowerSagittal_IndividualHopsContactPhase( HipGenerationFrames );
                                            
                                            
                                        else
                                        
                                            %This loop will actually integrate the Gth power absorption
                                            %period using trapezoidal integration. The number of loops
                                            %is one less than hte number of frames in the Gth period of
                                            %ankle power absorption. The reason for this is that the
                                            %integration uses two data points at a time - if we don't
                                            %subtract 1 from the number of data points, the last loop
                                            %will try to access a data point that doesn't exist.
                                            for h = 1 : ( length( HipGenerationFrames ) - 1 )

                                                %Perform trapezoidal integration. Formula is 0.5 * (
                                                %height * (base 1 + base 2 ) ). Height is the time step
                                                %in between data points. Base 1 is one power value,
                                                %Base 2 is the adjacent power value
                                                HipPositiveWork_TempVector( RowtoFill_HipPositiveWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( HipPowerSagittal_IndividualHopsContactPhase( HipGenerationFrames( h )   ) +...
                                                    HipPowerSagittal_IndividualHopsContactPhase( HipGenerationFrames( h + 1 )   )        )       );

                                                %Add 1 to RowtoFill_HipPositiveWork so that the next
                                                %row of HipPositiveWork_TempVector is filled 
                                                RowtoFill_HipPositiveWork = RowtoFill_HipPositiveWork + 1;
                                                
                                            end
                                    
                                        end
                                        
                                        %Fill in the Gth row of HipPositiveWork_CumSum by summing
                                        %all data points in HipPositiveWork_TempVector
                                        HipPositiveWork_CumSum( g ) = sum( HipPositiveWork_TempVector );
                                        
                                    end
                                        
                                    %Sum the lengths of the different periods of ankle generation,
                                    %to find total time spent in ankle generation
                                    LengthofHipGeneration_Sec( s ) = sum( LengthofHipGeneration_Sec_TempVector );    
                                    
                                    %Sum all values of HipPositiveWork_TempVector to get total
                                    %ankle nnegative work
                                    TotalHipPositiveWork_AllPeriodsAcrossContactPhase( s ) = sum( HipPositiveWork_CumSum );
                                    
                                    %Divide TotalHipPositiveWork by LengthofHipGeneration_Sec to
                                    %obtain total ankle positive power
                                    TotalPositivePower_Hip_EntireContactPhase(s) = TotalHipPositiveWork_AllPeriodsAcrossContactPhase( s ) ./ LengthofHipGeneration_Sec( s );






                                    
                                    
                                    
                                    
%% Calculate Positive Work for Hip

%                                     %Initialize vectors to hold the individual data points for
%                                     %negative and positive work. The number of data points in each
%                                     %temporary vector = 1 less than the number of positive or
%                                     %negative Frames
%                                     HipPositiveWork_TempVector = NaN( 1, 1);
%                                     RowtoFill_HipPositiveWork = 1;
%                                     
%                                     %Calculate negative work for ankle
%                                     for xa1 = 1 : ( length( HipPowerSagittal_PositiveFrames_EntireContactPhase ) - 1 )
%                                     
%                                         %We only want to integrate adjacent data points. Example: If the
%                                         %xa1st index is data point 11 but the xa1+1st is data point
%                                         %26, don't integrate these because there is a gap betwee the
%                                         %data points.
%                                         if HipPowerSagittal_PositiveFrames_EntireContactPhase( xa1 + 1 ) - HipPowerSagittal_PositiveFrames_EntireContactPhase( xa1 )  == 1
%                                             
%                                             %Perform trapezoidal integration. Formula is 0.5 * (
%                                             %height * (base 1 + base 2 ) ). Height is the time step
%                                             %in between data points. Base 1 is one power value,
%                                             %Base 2 is the adjacent power value
%                                             HipPositiveWork_TempVector( RowtoFill_HipPositiveWork ) = 0.5 .* ( ( 1./MoCapSampHz ) .* ( HipPowerSagittal_IndividualHopsContactPhase( HipPowerSagittal_PositiveFrames_EntireContactPhase( xa1 )   ) +...
%                                                 HipPowerSagittal_IndividualHopsContactPhase( HipPowerSagittal_PositiveFrames_EntireContactPhase( xa1 + 1 )   )        )       );
%                                         
%                                             %Add 1 to RowtoFill_HipPositiveWork so that the next
%                                             %row of HipPositiveWork_TempVector is filled 
%                                             RowtoFill_HipPositiveWork = RowtoFill_HipPositiveWork + 1;
%                                             
%                                         end
%                                         
%                                     end
%                                     
%                                     %Sum all values of HipPositiveWork_TempVector to get total
%                                     %ankle nnegative work
%                                     TotalHipPositiveWork( s ) = sum( HipPositiveWork_TempVector );                                            
                                    
                                    
                                    
                                    
                                    if TotalHipPositiveWork_AllPeriodsAcrossContactPhase( s ) < 0 || TotalHipNegativeWork_AllPeriodsAcrossContactPhase( s ) >=0
    
                                        %Calculate ratio between positive and negative work
                                        HipWorkRatio_EntireContactPhase( s ) =NaN;

                                    else
    
                                        %Calculate ratio between positive and negative work
                                        HipWorkRatio_EntireContactPhase( s ) = abs( TotalHipPositiveWork_AllPeriodsAcrossContactPhase( s ) ./ TotalHipNegativeWork_AllPeriodsAcrossContactPhase( s ) );
                                    
                                    end
                                    
                                    
                                    
                                    
                                    
                                    
                                    %Total negative and positive power across all joints (ankle, knee, hip)
                                    %- entire hop cycle
                                    TotalNegativePower_AllJoints_EntireContactPhase(s) =...
                                        TotalNegativePower_Ankle_EntireContactPhase(s)+TotalNegativePower_Knee_EntireContactPhase(s)+TotalNegativePower_Hip_EntireContactPhase(s);
                                    TotalPositivePower_AllJoints_EntireContactPhase(s) =...
                                        TotalPositivePower_Ankle_EntireContactPhase(s)+TotalPositivePower_Knee_EntireContactPhase(s)+TotalPositivePower_Hip_EntireContactPhase(s);


                                    %Joint contributions to total negative power across all joints - for
                                    %peak GRF as segmenting point
                                    PercentNegativePower_Ankle_EntireContactPhase(s) = TotalNegativePower_Ankle_EntireContactPhase(s)./TotalNegativePower_AllJoints_EntireContactPhase(s);
                                    PercentNegativePower_Knee_EntireContactPhase(s) = TotalNegativePower_Knee_EntireContactPhase(s)./TotalNegativePower_AllJoints_EntireContactPhase(s);
                                    PercentNegativePower_Hip_EntireContactPhase(s) = TotalNegativePower_Hip_EntireContactPhase(s)./TotalNegativePower_AllJoints_EntireContactPhase(s);

                                    %Joint contributions to total positive power across all joints - for
                                    %peak GRF as segmenting point
                                    PercentPositivePower_Ankle_EntireContactPhase(s) = TotalPositivePower_Ankle_EntireContactPhase(s)./TotalPositivePower_AllJoints_EntireContactPhase(s);
                                    PercentPositivePower_Knee_EntireContactPhase(s) = TotalPositivePower_Knee_EntireContactPhase(s)./TotalPositivePower_AllJoints_EntireContactPhase(s);
                                    PercentPositivePower_Hip_EntireContactPhase(s) = TotalPositivePower_Hip_EntireContactPhase(s)./TotalPositivePower_AllJoints_EntireContactPhase(s);





                                    


        %%  *Total Work Calculation*

                                     string_Angle = sprintf('Angle (%c)',char(176));

                                    %Find the time in s between data points. Will be used for integrating
                                    %power into work.
                                    TimeBetweenDataPoints = 1./60;

                                    %Next, we'll integrate joint power and torque. We want to know
                                    %how many individual data points we'll end up with before
                                    %summing them together for the total. The number of individual
                                    %data points is 1 less than the length of the contact phase
                                    LengthofWorkData_TrialX = NumEl_SthHopContactPhase_MoCapSamplingHz(s,q)-1;
                                    
                                    
                                    
 %% *Calculate Torque Impulse - Entire Contact Phase                                   
                                    
                                   %Convert frame of minimum L5-S1 vertical position, from motion
                                  %capture sampling Hz to GRF sampling Hz
                                  FrameofMinL5S1Position_EndBraking_GRFSampHz(s) = ( FrameofMinL5S1Position_EndBraking(s) ./ MoCapSampHz ) .* GRFSampHz;
                                  FrameofMinL5S1Position_BeginPropulsion_GRFSampHz(s) =FrameofMinL5S1Position_EndBraking_GRFSampHz(s)+1;
 
                                  
                                  
                                  
                                    %Initialize vectors to hold individual data points of
                                    %ankle/knee/hip torque impulse. Will later sum these to obtain
                                    %total joint torque impulse
                                    AnkleSagittalTorqueImpulse_TempVector = NaN( 1, 1 );
                                    KneeSagittalTorqueImpulse_TempVector = NaN( 1, 1 );
                                    HipSagittalTorqueImpulse_TempVector = NaN( 1, 1 );


                                    AnkleFrontalTorqueImpulse_TempVector = NaN( 1, 1 );
                                    KneeFrontalTorqueImpulse_TempVector = NaN( 1, 1 );
                                    HipFrontalTorqueImpulse_TempVector = NaN( 1, 1 );


                                    AnkleTransverseTorqueImpulse_TempVector = NaN( 1, 1 );
                                    KneeTransverseTorqueImpulse_TempVector = NaN( 1, 1 );
                                    HipTransverseTorqueImpulse_TempVector = NaN( 1, 1 );
                                    
                                    
                                    %For loop for integrating ankle, knee, and hip power and torque.
                                    for x = 1:(NumEl_SthHopContactPhase_MoCapSamplingHz(s,q)-1)


                                        %Height of trapezoidal integration is difference between the
                                        %time (in seconds) between the two data points.
                                        %TimePointT_inSec is the time for Data Point X,
                                        %TimePointTPluseOne_inSec is the time for Data Point X+1
                                        TimePointT_inSec = x./MoCapSampHz;
                                        TimePointTPlusOne_inSec = (x+1)./MoCapSampHz;

                                        %Integrate ankle power for entire contact phase, to
                                        %calculate ankle work. %Perform trapezoidal integration. Formula is 0.5 * (
                                        %height * (base 1 + base 2 ) ). Height is the time step
                                        %in between data points. Base 1 is one power value,
                                        %Base 2 is the adjacent power value
                                        AnkleWork_EntireContactPhase(x,s) =...
                                            (0.5*(AnklePowerSagittal_IndividualHopsContactPhase(x,s)+AnklePowerSagittal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        %Integrate knee power for entire contact phase, to
                                        %calculate ankle work. %Perform trapezoidal integration. Formula is 0.5 * (
                                        %height * (base 1 + base 2 ) ). Height is the time step
                                        %in between data points. Base 1 is one power value,
                                        %Base 2 is the adjacent power value
                                        KneeWork_EntireContactPhase(x,s) =...
                                            (0.5*(KneePowerSagittal_IndividualHopsContactPhase(x,s)+KneePowerSagittal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );

                                        %Integrate hip power for entire contact phase, to
                                        %calculate ankle work. %Perform trapezoidal integration. Formula is 0.5 * (
                                        %height * (base 1 + base 2 ) ). Height is the time step
                                        %in between data points. Base 1 is one power value,
                                        %Base 2 is the adjacent power value
                                        HipWork_EntireContactPhase(x,s) =...
                                            (0.5*(HipPowerSagittal_IndividualHopsContactPhase(x,s)+HipPowerSagittal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        
                                        




                                        %Integrate ankle torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        AnkleSagittalTorqueImpulse_TempVector(x) =...
                                            (0.5*(AnkleTorqueSagittal_IndividualHopsContactPhase(x,s)+AnkleTorqueSagittal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        
                                        %Integrate knee torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        KneeSagittalTorqueImpulse_TempVector(x) =...
                                            (0.5*(KneeTorqueSagittal_IndividualHopsContactPhase(x,s)+KneeTorqueSagittal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        
                                        
                                        %Integrate hip torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        HipSagittalTorqueImpulse_TempVector(x) =...
                                            (0.5*(HipTorqueSagittal_IndividualHopsContactPhase(x,s)+HipTorqueSagittal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        





                                        
                                        
                                        %Integrate ankle torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        AnkleFrontalTorqueImpulse_TempVector(x) =...
                                            (0.5*(AnkleTorqueFrontal_IndividualHopsContactPhase(x,s)+AnkleTorqueFrontal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        
                                        %Integrate knee torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        KneeFrontalTorqueImpulse_TempVector(x) =...
                                            (0.5*(KneeTorqueFrontal_IndividualHopsContactPhase(x,s)+KneeTorqueFrontal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        
                                        
                                        %Integrate hip torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        HipFrontalTorqueImpulse_TempVector(x) =...
                                            (0.5*(HipTorqueFrontal_IndividualHopsContactPhase(x,s)+HipTorqueFrontal_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        





                                        
                                        %Integrate ankle torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        AnkleTransverseTorqueImpulse_TempVector(x) =...
                                            (0.5*(AnkleTorqueTransverse_IndividualHopsContactPhase(x,s)+AnkleTorqueTransverse_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        
                                        %Integrate knee torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        KneeTransverseTorqueImpulse_TempVector(x) =...
                                            (0.5*(KneeTorqueTransverse_IndividualHopsContactPhase(x,s)+KneeTorqueTransverse_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );
                                        
                                        
                                        
                                        %Integrate hip torque for entire contact phase. Perform trapezoidal integration. Formula is 0.5 * (
                                            %height * (base 1 + base 2 ) ). Height is the time step
                                            %in between data points. Base 1 is one torque value,
                                            %Base 2 is the adjacent torque value
                                        HipTransverseTorqueImpulse_TempVector(x) =...
                                            (0.5*(HipTorqueTransverse_IndividualHopsContactPhase(x,s)+HipTorqueTransverse_IndividualHopsContactPhase(x,s) )).*...
                                            (TimePointTPlusOne_inSec- TimePointT_inSec );



                                    end

                                    
                                    %Find total ankle work by summing all values in
                                    %AnkleWork_EntireContactPhase
                                    TotalAnkleWork_EntireContactPhase(s) = sum( AnkleWork_EntireContactPhase( 1 : LengthofWorkData_TrialX, s ) );
                                    
                                    %Find total knee work by summing all values in
                                    %KneeWork_EntireContactPhase
                                    TotalKneeWork_EntireContactPhase(s) = sum( KneeWork_EntireContactPhase( 1 : LengthofWorkData_TrialX, s ) );
                                    
                                    %Find total hip work by summing all values in
                                    %HipWork_EntireContactPhase
                                    TotalHipWork_EntireContactPhase(s) = sum( HipWork_EntireContactPhase( 1 : LengthofWorkData_TrialX, s ) );
                                    
                                    
                                    
                                    
                                    
                                    %Find total ankle torque by summing all values in
                                    %AnkleTorqueImpulse_TempVector
                                    TotalAnkleSagittalTorqueImpulse_EntireContactPhase(s) = sum( AnkleSagittalTorqueImpulse_TempVector );
                                    
                                    %Find total knee torque by summing all values in
                                    %KneeTorqueImpulse_TempVector
                                    TotalKneeSagittalTorqueImpulse_EntireContactPhase(s) = sum( KneeSagittalTorqueImpulse_TempVector );
                                    
                                    %Find total hip torque by summing all values in
                                    %HipTorqueImpulse_TempVector
                                    TotalHipSagittalTorqueImpulse_EntireContactPhase(s) = sum( HipSagittalTorqueImpulse_TempVector );
                                    










          %% Interpolate the data!
                                    VectorforInterpolatingDatatoDesiredLength = linspace(0,100,NumEl_SthHopContactPhase_MoCapSamplingHz(s,q));
                                    DesiredLengthofWorkData(s) = numel(VectorforInterpolatingDatatoDesiredLength);
                                    CurrentLengthofWorkData = linspace(0,100, LengthofWorkData_TrialX);


                                    AnkleWork_EntireContactPhase_InterpolatedforWorkLoop(1:DesiredLengthofWorkData(s),s) =...
                                        interp1(CurrentLengthofWorkData,AnkleWork_EntireContactPhase(1:LengthofWorkData_TrialX,s), VectorforInterpolatingDatatoDesiredLength);

                                    KneeWork_EntireContactPhase_InterpolatedforWorkLoop(1:DesiredLengthofWorkData(s),s) =...
                                        interp1(CurrentLengthofWorkData,KneeWork_EntireContactPhase(1:LengthofWorkData_TrialX,s), VectorforInterpolatingDatatoDesiredLength);

                                    HipWork_EntireContactPhase_InterpolatedforWorkLoop(1:DesiredLengthofWorkData(s),s) =...
                                        interp1(CurrentLengthofWorkData,HipWork_EntireContactPhase(1:LengthofWorkData_TrialX,s), VectorforInterpolatingDatatoDesiredLength);




%% Calculate Hopping Height


                                
                                %Find the nontruncated duration of the flight phase for Hop S, in
                                %frames
                                LengthofFlightPhase_NonTruncated_MoCapSampHz( s ) = numel( GContactEnd_forHoppingHeight_MoCapFrameNumbers( s ): GContactBegin_forHoppingHeight_MoCapFrameNumbers( s ) -1 );
                                
                                %Find length of flight phase in seconds, using GRF frame numbers
                                LengthofFlightPhase_NonTruncated_GRFSampHz = numel( GContactEnd_forFlightPhase_GRFFrameNumbers( s ) : ( GContactBegin_GRFFrameNumbers( s ) - 1 ) );

                                %Find the nontruncated duration of the flight phase for Hop S
                                LengthofFlightPhase_Seconds( s ) = LengthofFlightPhase_NonTruncated_GRFSampHz ./ EMGSampHz;




                                %ATx25 is missing L5-S1 marker for Involved Limb, 2.3 Hz. Use LPSIS
                                %instead
                                if strcmp( ParticipantList{ n }, 'ATx25' ) && strcmp( LimbID{a}, 'InvolvedLimb' ) && strcmp( HoppingRate_ID{ b }, 'TwoPoint3Hz' )
                                    
                                    %Hopping height = maximum vertical position of L5-S1 marker (during flight phase) minus
                                    %vertical position at end of ground contact phase
                                    HoppingHeight(s) = max( HoppingTrialP_OriginalDataTable.LPSIS_2( GContactEnd_forHoppingHeight_MoCapFrameNumbers( s ): GContactBegin_forHoppingHeight_MoCapFrameNumbers( s ) ), [],  'omitnan'  ) - HoppingTrialP_OriginalDataTable.LPSIS_2( GContactEnd_forHoppingHeight_MoCapFrameNumbers(s) );


                                else

                                    %Hopping height = maximum vertical position of L5-S1 marker (during flight phase) minus
                                    %vertical position at end of ground contact phase
                                    HoppingHeight(s) = max( HoppingTrialP_OriginalDataTable.L5S1_2( GContactEnd_forHoppingHeight_MoCapFrameNumbers( s ): GContactBegin_forHoppingHeight_MoCapFrameNumbers( s ) ), [],  'omitnan'  ) - HoppingTrialP_OriginalDataTable.L5S1_2( GContactEnd_forHoppingHeight_MoCapFrameNumbers(s) );


                                end

                                





%% !!ADD Total and Percent Positive and Negative Power Data to a Table for Exporting to R

                                    
                                %If you have NOT added Participant N Data, add it to the data structure
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )
            

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,1) = m; %Store Group ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,2) = n; %Store Participant ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,3) = a; %Store Limb ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,4) = 1; %Store MTU ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,5) = q; %Store Trial ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,6) = s; %Store Hop ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,7) = 1; %Store Joint ID - Ankle = 1
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 8) = HoppingRate_ID_forTable(b);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,9) = TotalNegativePower_Ankle_EntireContactPhase(s); %Store TotalNegativePower_Ankle_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,10) = TotalPositivePower_Ankle_EntireContactPhase(s); %Store TotalPositivePower_Ankle_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,11) = PercentNegativePower_Ankle_EntireContactPhase(s); %Store PercentNegativePower_Ankle_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,12) = PercentPositivePower_Ankle_EntireContactPhase(s); %Store PercentPositivePower_Ankle_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,13) = TotalNegativePower_AllJoints_EntireContactPhase(s); %Store TotalNegativePower_AllJoints_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,14) = TotalPositivePower_AllJoints_EntireContactPhase(s); %Store TotalPositivePower_AllJoints_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,15) = TotalAnkleNegativeWork_AllPeriodsAcrossContactPhase(s); %Store TotalAnkleNegativeWork
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,16) = TotalAnklePositiveWork_AllPeriodsAcrossContactPhase(s); %Store TotalAnklePositiveWork
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,17) = AnkleWorkRatio_EntireContactPhase(s); %Store AnkleWorkRatio
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,18)  = TotalAnkleWork_EntireContactPhase( s ); %Store total ankle work
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,19)  = TotalAnkleSagittalTorqueImpulse_EntireContactPhase( s ); %Store total ankle torque impulse
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 20)  = AnklePercentMEEAbsorption( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 21)  = AnklePercentMEEGeneration( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 22)  = WholeLimbAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 23)  = WholeLimbGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 24)  = AnkleAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 25)  = AnkleGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 26)  = AnkleTorqueImpulse_Braking_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 27)  = AnkleTorqueImpulse_Propulsion_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 28)  = max( AnkleSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ), [],  'omitnan' );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 29)  = min( AnkleSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ), [],  'omitnan' );                                
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 30)  = HoppingHeight(s);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 31) = LimbAbsorptionWorkRatio( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 32) = LimbGenerationWorkRatio( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 33)  = AnklePercentMEEContact( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 34)  = WholeLimbContactMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 35)  = AnkleContactMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 36)  = AnkleContactSagittalTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 37)  = AnkleandKneeContactMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 38)  = AnklePercentMEE_ofAnkleandKneeMEE_Contact( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 39)  = KneePercentMEE_ofAnkleandKneeMEE_Contact( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 40)  = AnkleandKneeAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 41)  = AnklePercentMEE_ofAnkleandKneeMEE_Braking( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 42)  = KneePercentMEE_ofAnkleandKneeMEE_Braking( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 43)  = AnkleandKneeGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 44)  = AnklePercentMEE_ofAnkleandKneeMEE_Propulsion( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 45)  = KneePercentMEE_ofAnkleandKneeMEE_Propulsion( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 46)  = AnkleContactFrontalTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 47)  = AnkleContactTransverseTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 48)  = AnkleTorqueImpulse_Braking_Frontal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 49)  = AnkleTorqueImpulse_Propulsion_Frontal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 50)  = AnkleTorqueImpulse_Braking_Transverse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 51)  = AnkleTorqueImpulse_Propulsion_Transverse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 52)  = AnkleSagittalRoM_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 53)  = AnkleSagittalRoM_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 54)  = LengthofFlightPhase_Seconds( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 55)  = LengthofContactPhase_Seconds( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 56)  = LengthofBrakingPhase_Seconds( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 57)  = LengthofPropulsionPhase_Seconds( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 58)  = AverageAnkleAbsorptionAngVel_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 59)  = AverageAnkleGenerationAngVel_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 60)  = TimetoPeakDF_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 61)  = TimetoPeakPF_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 62)  = TimetoPeakDFAngVel_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 63)  = TimetoPeakPFAngVel_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 64)  = AnkleAngleAtPeakAngVel_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 65)  = AnkleAngleAtPeakAngVel_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 66)  = PeakDF_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 67)  = PeakPF_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 68)  = LengthofHopCycle_sec( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 69)  = HopFrequency( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 70)  = AnkleInitialContactAngle( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 71)  = AnkleInitialPropulsionPhaseAngle( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 72)  = AnkleAverageBrakingTorqueImpulse_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 73)  = AnkleAveragePropulsionTorqueImpulse_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 74)  = TotalLimbSupportMoment_AllJointsExtensor_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 75)  = TotalAnkleSupportMoment_AllJointsExtensor_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 76)  = AnkleContribution_SupportMoment_AllJointsExtensor_Braking( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 77)  = AnkleContribution_PeakSupportMoment_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 78)  = PeakSupportMoment_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 79)  = TotalLimbSupportPower_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 80)  = TotalAnkleSupportPower_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 81)  = AnkleContribution_SupportPower_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 82)  = TotalLimbSupportMoment_AllJointsExtensor_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 83)  = TotalAnkleSupportMoment_AllJointsExtensor_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 84)  = AnkleContribution_SupportMoment_AllJointsExtensor_Propulsion( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 85)  = AnkleContribution_PeakSupportMoment_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 86)  = PeakSupportMoment_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 87)  = TotalLimbSupportPower_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 88)  = TotalAnkleSupportPower_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 89)  = AnkleContribution_SupportPower_PropulsionPhase( s );


                                   %Add between-limb tendon thickness for each participant to Column 35.
                                    %Add VAS Pain Rating to Column 36
                                    if strcmp( LimbID{ a}, 'InvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                
                                         %Set the between-limb morphology
                                        Power_EntireContactPhase( RowtoFill_Power_EntireContactPhase, 90) = ATxMorphology(  n );
                                         
                                         %Set theVAS rating
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91) = ATxVAS_Involved_PreferredHz( n );


                                    elseif strcmp( LimbID{ a}, 'InvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz')
                
                                         %Set the between-limb morphology
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90) = ATxMorphology(  n );
                                         
                                         %Set theVAS rating
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91) = ATxVAS_Involved_TwoHz( n );

                                        
                                    elseif strcmp( LimbID{ a}, 'InvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                
                                         %Set the between-limb morphology
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90) = ATxMorphology(  n );
                                         
                                         %Set theVAS rating
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91) = ATxVAS_Involved_TwoPoint3Hz( n );


                                    elseif strcmp( LimbID{ a}, 'NonInvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                
                                         %Set the between-limb morphology
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90) = ATxMorphology(  n );
                                         
                                         %Set theVAS rating
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91) = ATxVAS_NonInvolved_PreferredHz( n );


                                    elseif strcmp( LimbID{ a}, 'NonInvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz')
                
                                         %Set the between-limb morphology
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90) = ATxMorphology(  n );
                                         
                                         %Set theVAS rating
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91) = ATxVAS_NonInvolved_TwoHz( n );

                                        
                                    elseif strcmp( LimbID{ a}, 'NonInvolvedLimb'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                
                                         %Set the between-limb morphology
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90) = ATxMorphology(  n );
                                         
                                         %Set theVAS rating
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91) = ATxVAS_NonInvolved_TwoPoint3Hz( n );
                
                                    else
                
                                         %Set the between-limb morphology
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90)  = ControlMorphology(  n );
                                         
                                         %Set theVAS rating
                                        Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91)  = ControlVAS;

                                    end



                                     %Add anklework for entire braking phase to matrix
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 92) = AnkleAbsorptionWork( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 93) = AnkleWorkContribution_BrakingPhase( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 94) = WholeLimbWork_BrakingPhase( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 95) = AnkleGenerationWork( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 96) = AnkleWorkRatio_PropulsionvsBrakingPhase( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 97) = WholeLimbWork_PropulsionPhase( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 98) = TotalLimbSupportMoment_Braking_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 99) = TotalAnkleSupportMoment_Braking_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 100) = AnkleContribution_BrakingPhase_AllNegativeSupportMoment( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 101) = TotalLimbSupportPower_Braking_AllNegativeSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 102) = TotalAnkleSupportPower_Braking_AllNegativeSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 103) = AnkleContribution_BrakingPhase_AllNegativeSupportPower( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 104) = TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 105) = TotalAnkleSupportMoment_Propulsion_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 106) = AnkleContribution_PropulsionPhase_AllNegativeSupportMoment( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 107) = TotalLimbSupportPower_Propulsion_AllPositiveSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 108) = TotalAnkleSupportPower_Propulsion_AllPositiveSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 109) = AnkleContribution_PropulsionPhase_AllPositiveSupportPower( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 110) = AnkleWorkContribution_PropulsionPhase( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 111) = TotalLimbSupportMoment_Braking_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 112) = TotalAnkleSupportMoment_Braking_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 113) = AnkleSupportMomentContribution_Braking_NoFlexorTorque( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 114) = TotalLimbSupportMoment_Propulsion_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 115) = TotalAnkleSupportMoment_Propulsion_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 116) = AnkleSupportMomentContribution_Propulsion_NoFlexorTorque( s );
    
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 117) = AnkleWork_Braking_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 118) =  WholeLimbWork_Braking_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 119) = AnkleWorkContribution_Braking_GenerationNeutralized( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 120) = AnkleWork_Propulsion_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 121) = WholeLimbWork_Propulsion_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 122) = AnkleWorkContribution_Propulsion_AbsorptionNeutralized( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 123) = AnkleAverageAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 124) = WholeLimbAverageAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 125) = AnklePercentAverageMEEAbsorption( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 126) = AnkleAverageGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 127) = WholeLimbAverageGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 128) = AnklePercentAverageMEEGeneration( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 129) = AnkleAveragePower_BrakingPhase_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 130) = LimbAveragePower_BrakingPhase_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 131) = AnkleContribution_AveragePower_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 132) = AnkleAveragePower_PropulsionPhase_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 133) = LimbAveragePower_PropulsionPhase_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 134) = AnkleContribution_AveragePower_AbsorptionNeutralized( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 135) = TotalLimbAverageTorqueImpulse_Braking_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 136) = AnkleAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 137) = AnkleContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 138) = TotalLimbAverageTorqueImpulse_Propulsion_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 139) = AnkleAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 140) = AnkleContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 141) = TotalLimbAverageTorqueImpulse_Braking_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 142) = AnkleAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 143) = AnkleContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 144) = TotalLimbAverageTorqueImpulse_Propulsion_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 145) = AnkleAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 146) = AnkleContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 147) = TotalLimbAverageTorqueImpulse_Braking_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 148) = AnkleAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 149) = AnkleContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 150) = TotalLimbAverageTorqueImpulse_Propulsion_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 151) = AnkleAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 152) = AnkleContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq( s );





                                    %Add 1 to RowtoFill_Power_EntireContactPhase so that next loop iteration
                                    %will add data to the next row
                                    RowtoFill_Power_EntireContactPhase = RowtoFill_Power_EntireContactPhase + 1;
                                    
                                    
                                    
                                    
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,1) = m; %Store Group ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,2) = n; %Store Participant ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,3) = a; %Store Limb ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,4) = 1; %Store MTU ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,5) = q; %Store Trial ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,6) = s; %Store Hop ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,7) = 2; %Store Joint ID - Knee = 2
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 8) = HoppingRate_ID_forTable(b);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,9) = TotalNegativePower_Knee_EntireContactPhase(s); %Store TotalNegativePower_Knee_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,10) = TotalPositivePower_Knee_EntireContactPhase(s); %Store TotalPositivePower_Knee_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,11) = PercentNegativePower_Knee_EntireContactPhase(s); %Store PercentNegativePower_Knee_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,12) = PercentPositivePower_Knee_EntireContactPhase(s); %Store PercentPositivePower_Knee_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,13) = TotalNegativePower_AllJoints_EntireContactPhase(s); %Store TotalNegativePower_AllJoints_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,14) = TotalPositivePower_AllJoints_EntireContactPhase(s); %Store TotalPositivePower_AllJoints_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,15) = TotalKneeNegativeWork_AllPeriodsAcrossContactPhase(s); %Store TotalKneeNegativeWork
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,16) = TotalKneePositiveWork_AllPeriodsAcrossContactPhase(s); %Store TotalKneePositiveWork
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,17) = KneeWorkRatio_EntireContactPhase(s); %KneeWorkRatio
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,18)  = TotalKneeWork_EntireContactPhase( s ); %Store total ankle work
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,19)  = TotalKneeSagittalTorqueImpulse_EntireContactPhase( s ); %Store total knee torque impulse
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 20)  = KneePercentMEEAbsorption( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 21)  = KneePercentMEEGeneration( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 22)  = WholeLimbAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 23)  = WholeLimbGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 24)  = KneeAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 25)  = KneeGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 26)  = KneeTorqueImpulse_Braking_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 27)  = KneeTorqueImpulse_Propulsion_Sagittal( s );             
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 28)  = max( KneeSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ), [],  'omitnan' );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 29)  = min( KneeSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ), [],  'omitnan' );     
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 30)  = HoppingHeight(s);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 31) = LimbAbsorptionWorkRatio( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 32) = LimbGenerationWorkRatio( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 33)  = KneePercentMEEContact( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 34)  = WholeLimbContactMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 35)  = KneeContactMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 36)  = KneeContactSagittalTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 37)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 38)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 39)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 40)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 41)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 42)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 43)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 44)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 45)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 46)  = KneeContactFrontalTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 47)  = KneeContactTransverseTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 48)  = KneeTorqueImpulse_Braking_Frontal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 49)  = KneeTorqueImpulse_Propulsion_Frontal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 50)  = KneeTorqueImpulse_Braking_Transverse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 51)  = KneeTorqueImpulse_Propulsion_Transverse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 52)  = KneeSagittalRoM_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 53)  = KneeSagittalRoM_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 54)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 55)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 56)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 57)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 58)  = AverageKneeAbsorptionAngVel_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 59)  = AverageKneeGenerationAngVel_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 60)  = TimetoPeakKneeFlex_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 61)  = TimetoPeakKneeExt_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 62)  = TimetoPeakKneeFlexAngVel_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 63)  = TimetoPeakKneeExtAngVel_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 64)  = KneeAngleAtPeakAngVel_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 65)  = KneeAngleAtPeakAngVel_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 66)  = PeakKneeFlex_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 67)  = PeakKneeExt_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 68)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 69)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 70)  = KneeInitialContactAngle( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 71)  = KneeInitialPropulsionPhaseAngle( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 72)  = KneeAverageBrakingTorqueImpulse_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 73)  = KneeAveragePropulsionTorqueImpulse_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 74)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 75)  = TotalKneeSupportMoment_AllJointsExtensor_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 76)  = KneeContribution_SupportMoment_AllJointsExtensor_Braking( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 77)  = KneeContribution_PeakSupportMoment_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 78)  = PeakSupportMoment_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 79)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 80)  = TotalKneeSupportPower_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 81)  = KneeContribution_SupportPower_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 82)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 83)  = TotalKneeSupportMoment_AllJointsExtensor_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 84)  = KneeContribution_SupportMoment_AllJointsExtensor_Propulsion( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 85)  = KneeContribution_PeakSupportMoment_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 86)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 87)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 88)  = TotalKneeSupportPower_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 89)  = KneeContribution_SupportPower_PropulsionPhase( s );

                                     %Set the between-limb morphology
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90)  = NaN;
                                     
                                     %Set theVAS rating
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91)  = NaN;       

                                     %Add anklework for entire braking phase to matrix
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 92) = KneeAbsorptionWork( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 93) = KneeWorkContribution_BrakingPhase( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 94) = NaN;
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 95) = KneeGenerationWork( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 96) = KneeWorkRatio_PropulsionvsBrakingPhase( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 97) = NaN;

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 98) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 99) = TotalKneeSupportMoment_Braking_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 100) = KneeContribution_BrakingPhase_AllNegativeSupportMoment( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 101) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 102) = TotalKneeSupportPower_Braking_AllNegativeSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 103) = KneeContribution_BrakingPhase_AllNegativeSupportPower( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 104) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 105) = TotalKneeSupportMoment_Propulsion_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 106) = KneeContribution_PropulsionPhase_AllNegativeSupportMoment( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 107) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 108) = TotalKneeSupportPower_Propulsion_AllPositiveSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 109) = KneeContribution_PropulsionPhase_AllPositiveSupportPower( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 110) = KneeWorkContribution_PropulsionPhase( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 111) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 112) = TotalKneeSupportMoment_Braking_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 113) = KneeSupportMomentContribution_Braking_NoFlexorTorque( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 114) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 115) = TotalKneeSupportMoment_Propulsion_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 116) = KneeSupportMomentContribution_Propulsion_NoFlexorTorque( s );
    
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 117) = KneeWork_Braking_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 118) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 119) = KneeWorkContribution_Braking_GenerationNeutralized( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 120) = KneeWork_Propulsion_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 121) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 122) = KneeWorkContribution_Propulsion_AbsorptionNeutralized( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 123) = KneeAverageAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 124) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 125) = KneePercentAverageMEEAbsorption( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 126) = KneeAverageGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 127) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 128) = KneePercentAverageMEEGeneration( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 129) = KneeAveragePower_BrakingPhase_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 130) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 131) = KneeContribution_AveragePower_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 132) = KneeAveragePower_PropulsionPhase_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 133) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 134) = KneeContribution_AveragePower_AbsorptionNeutralized( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 135) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 136) = KneeAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 137) = KneeContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 138) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 139) = KneeAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 140) = KneeContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 141) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 142) = KneeAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 143) = KneeContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 144) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 145) = KneeAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 146) = KneeContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 147) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 148) = KneeAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 149) = KneeContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 150) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 151) = KneeAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 152) = KneeContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq( s );


                                    %Add 1 to RowtoFill_Power_EntireContactPhase so that next loop iteration
                                    %will add data to the next row
                                    RowtoFill_Power_EntireContactPhase = RowtoFill_Power_EntireContactPhase + 1;
                                    
                                    
                                    
                                    
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,1) = m; %Store Group ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,2) = n; %Store Participant ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,3) = a; %Store Limb ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,4) = 1; %Store MTU ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,5) = q; %Store Trial ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,6) = s; %Store Hop ID
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,7) = 3; %Store Joint ID - Hip = 3
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 8) = HoppingRate_ID_forTable(b);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,9) = TotalNegativePower_Hip_EntireContactPhase(s); %Store TotalNegativePower_Hip_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,10) = TotalPositivePower_Hip_EntireContactPhase(s); %Store TotalPositivePower_Hip_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,11) = PercentNegativePower_Hip_EntireContactPhase(s); %Store PercentNegativePower_Hip_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,12) = PercentPositivePower_Hip_EntireContactPhase(s); %Store PercentPositivePower_Hip_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,13) = TotalNegativePower_AllJoints_EntireContactPhase(s); %Store TotalNegativePower_AllJoints_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,14) = TotalPositivePower_AllJoints_EntireContactPhase(s); %Store TotalPositivePower_AllJoints_EntireContactPhase
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,15) = TotalHipNegativeWork_AllPeriodsAcrossContactPhase(s); %Store TotalHipNegativeWork
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,16) = TotalHipPositiveWork_AllPeriodsAcrossContactPhase(s); %Store TotalHipPositiveWork
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,17) = HipWorkRatio_EntireContactPhase(s); %HipWorkRatio
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,18)  = TotalHipWork_EntireContactPhase( s ); %Store total ankle work
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase,19)  = TotalHipSagittalTorqueImpulse_EntireContactPhase( s ); %Store total hip torque impulse
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 20)  = HipPercentMEEAbsorption( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 21)  = HipPercentMEEGeneration( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 22)  = WholeLimbAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 23)  = WholeLimbGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 24)  = HipAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 25)  = HipGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 26)  = HipTorqueImpulse_Braking_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 27)  = HipTorqueImpulse_Propulsion_Sagittal( s );             
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 28)  = max( HipSagittalAngVel_BrakingPhase_L5S1AsReference( 1 : LengthofBrakingPhase(s), s ), [],  'omitnan' );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 29)  = min( HipSagittalAngVel_PropulsionPhase_L5S1AsReference( 1 : LengthofPropulsionPhase(s), s ), [],  'omitnan' );     
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 30)  = HoppingHeight(s);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 31) = LimbAbsorptionWorkRatio( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 32) = LimbGenerationWorkRatio( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 33)  = HipPercentMEEContact( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 34)  = WholeLimbContactMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 35)  = HipContactMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 36)  = HipContactSagittalTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 37)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 38)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 39)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 40)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 41)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 42)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 43)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 44)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 45)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 46)  = HipContactFrontalTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 47)  = HipContactTransverseTorqueImpulse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 48)  = HipTorqueImpulse_Braking_Frontal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 49)  = HipTorqueImpulse_Propulsion_Frontal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 50)  = HipTorqueImpulse_Braking_Transverse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 51)  = HipTorqueImpulse_Propulsion_Transverse( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 52)  = HipSagittalRoM_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 53)  = HipSagittalRoM_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 54)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 55)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 56)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 57)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 58)  = AverageHipAbsorptionAngVel_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 59)  = AverageHipGenerationAngVel_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 60)  = TimetoPeakHipFlex_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 61)  = TimetoPeakHipExt_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 62)  = TimetoPeakHipFlexAngVel_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 63)  = TimetoPeakHipExtAngVel_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 64)  = HipAngleAtPeakAngVel_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 65)  = HipAngleAtPeakAngVel_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 66)  = PeakHipFlex_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 67)  = PeakHipExt_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 68)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 69)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 70)  = HipInitialContactAngle( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 71)  = HipInitialPropulsionPhaseAngle( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 72)  = HipAverageBrakingTorqueImpulse_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 73)  = HipAveragePropulsionTorqueImpulse_Sagittal( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 74)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 75)  = TotalHipSupportMoment_AllJointsExtensor_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 76)  = HipContribution_SupportMoment_AllJointsExtensor_Braking( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 77)  = HipContribution_PeakSupportMoment_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 78)  = PeakSupportMoment_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 79)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 80)  = TotalHipSupportPower_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 81)  = HipContribution_SupportPower_BrakingPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 82)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 83)  = TotalHipSupportMoment_AllJointsExtensor_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 84)  = HipContribution_SupportMoment_AllJointsExtensor_Propulsion( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 85)  = HipContribution_PeakSupportMoment_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 86)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 87)  = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 88)  = TotalHipSupportPower_PropulsionPhase( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 89)  = HipContribution_SupportPower_PropulsionPhase( s );

                                     %Set the between-limb morphology
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 90)  = NaN;
                                     
                                     %Set theVAS rating
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 91)  = NaN;       

                                     %Add Hipwork for entire braking phase to matrix
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 92) = HipAbsorptionWork( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 93) = HipWorkContribution_BrakingPhase( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 94) = NaN;
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 95) = HipGenerationWork( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 96) = HipWorkRatio_PropulsionvsBrakingPhase( s );
                                     Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 97) = NaN;

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 98) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 99) = TotalHipSupportMoment_Braking_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 100) = HipContribution_BrakingPhase_AllNegativeSupportMoment( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 101) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 102) = TotalHipSupportPower_Braking_AllNegativeSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 103) = HipContribution_BrakingPhase_AllNegativeSupportPower( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 104) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 105) = TotalHipSupportMoment_Propulsion_AllNegativeSupportMoment( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 106) = HipContribution_PropulsionPhase_AllNegativeSupportMoment( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 107) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 108) = TotalHipSupportPower_Propulsion_AllPositiveSupportPower( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 109) = HipContribution_PropulsionPhase_AllPositiveSupportPower( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 110) = HipWorkContribution_PropulsionPhase( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 111) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 112) = TotalHipSupportMoment_Braking_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 113) = HipSupportMomentContribution_Braking_NoFlexorTorque( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 114) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 115) = TotalHipSupportMoment_Propulsion_NoFlexorTorque( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 116) = HipSupportMomentContribution_Propulsion_NoFlexorTorque( s );
    
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 117) = HipWork_Braking_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 118) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 119) = HipWorkContribution_Braking_GenerationNeutralized( s );

                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 120) = HipWork_Propulsion_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 121) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 122) = HipWorkContribution_Propulsion_AbsorptionNeutralized( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 123) = HipAverageAbsorptionMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 124) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 125) = HipPercentAverageMEEAbsorption( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 126) = HipAverageGenerationMEE( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 127) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 128) = HipPercentAverageMEEGeneration( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 129) = HipAveragePower_BrakingPhase_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 130) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 131) = HipContribution_AveragePower_GenerationNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 132) = HipAveragePower_PropulsionPhase_AbsorptionNeutralized( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 133) = NaN;
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 134) = HipContribution_AveragePower_AbsorptionNeutralized( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 135) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 136) = HipAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 137) = HipContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 138) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 139) = HipAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 140) = HipContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 141) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 142) = HipAverageBrakingTorqueImpulse_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 143) = HipContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 144) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 145) = HipAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 146) = HipContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq( s );


                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 147) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 148) = HipAverageBrakingTorqueImpulse_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 149) = HipContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 150) = NaN(1,1);
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 151) = HipAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq( s );
                                    Power_EntireContactPhase(RowtoFill_Power_EntireContactPhase, 152) = HipContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq( s );



                                    %Add 1 to RowtoFill_Power_EntireContactPhase so that next loop iteration
                                    %will add data to the next row
                                    RowtoFill_Power_EntireContactPhase = RowtoFill_Power_EntireContactPhase + 1;

                                end
                                    

%% END S FOR LOOP - INDIVIDUAL HOPS
                                end





%% PLOT Hopping Height                                
                                
                                 if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )

                                     %Set the size, name, and background color of the figure
                                     figure('Color','w','Position', [-1679 31 1680 999],'Name',['Check Hopping Height  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ],'Visible',"on"  )

                                     plot( 1:length(HoppingHeight), HoppingHeight, 'Marker', '.', 'MarkerSize', 20)
                                     title('Hopping Height','FontSize',16)
                                    xlabel('Hop Number','FontSize',14)
                                    ylabel( 'Hopping Height (m)', 'FontSize',14)
                                    
                                    pause

                                    savefig( [ ParticipantList{n}, '_', 'HoppingHeight_cm', '_', LimbID{a} '  '  ' _ ' HoppingRate_ID{b}, '.fig' ] );
                                    
                                 end
                                
                                
                                 
%% Calculate Strut/Spring/Motor/Damper Frames


                                [AnkleStrutIndex, AnkleSpringIndex, AnkleMotorIndex, AnkleDamperIndex] = JointStrutIndex_Output( AnklePowerSagittal_IndividualHopsContactPhase, AnkleSagittalTorque_IndividualHops,...
                                    NumEl_SthHopContactPhase_MoCapSamplingHz(:,q), MoCapSampHz );

                                [KneeStrutIndex, KneeSpringIndex, KneeMotorIndex, KneeDamperIndex] = JointStrutIndex_Output( KneePowerSagittal_IndividualHopsContactPhase, KneeSagittalTorque_IndividualHops,...
                                    NumEl_SthHopContactPhase_MoCapSamplingHz(:,q), MoCapSampHz );
                                
                                [HipStrutIndex, HipSpringIndex, HipMotorIndex, HipDamperIndex] = JointStrutIndex_Output( HipPowerSagittal_IndividualHopsContactPhase, HipSagittalTorque_IndividualHops,...
                                    NumEl_SthHopContactPhase_MoCapSamplingHz(:,q), MoCapSampHz );


%% BEGIN Z LOOP - *Fill in JointBehaviorIndex matrix*                                
                                
                                %Fill in JointBehaviorIndex matrix. Run this loop once per hop -
                                %each hop is one column in AnklePowerSagittal_IndividualHopsContactPhase
                                for z = 1 : size( AnklePowerSagittal_IndividualHopsContactPhase, 2 )
                                
                                
                                                                    
                                    %If you are NOT reprocessing data, ask whether we have added any new participants
                                    if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 1; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 1; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = AnkleStrutIndex(z);%Hop number
    
                                         %For ATx07, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                        if strcmp( ParticipantList{n}, 'ATx07'  )
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 0.75;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.41;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 2;
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.41;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 1;
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.41;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                             
                                         %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb') && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.41;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 3;
                    
                                             
                                         %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.41;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 2;
                    
                                             
                                         %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.41;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 3;
                                            
                                            
                    
                    
                                             
                                         %For ATx10, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx10'  ) 
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.4;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 0.5;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 6;
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 0.5;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 6.5;
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 0.5;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 6;
                    
                                             
                                         %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb') 
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 0.5;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                             
                                             
                                             
                    
                                         %For ATx17, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.57;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                            
                                            
                                        %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.57;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 4;
                    
                                            
                                            
                                        %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.57;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 4;
                    
                                            
                                            
                                        %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.57;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 3;
                    
                                             
                                             
                                             
                                             
                                         %For ATx18, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 3.69;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                            
                                            
                                        %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 3.69;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 1;
                    
                                             
                                             
                                         
                    
                                             
                                         %For ATx19, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.58;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                            
                                        %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                    
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.58;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 2.5;
                    
                                            
                                        %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.58;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 3;
                    
                                            
                                        %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                    
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.58;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 3;
                    
                                             
                                             
                    
                    
                                             
                                         %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.21;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                            
                                        %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                                        %use 'R' in front of each muscle 
                                         elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.21;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                             
                    
                                             
                                         %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx24'  )
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.94;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                    
                    
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx25'  )
                    
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.84;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.84;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 3;
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.84;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 1;
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.84;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                    
                                             
                                         %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 2.84;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                    
                    
                    
                    
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( HoppingRate_ID{b}, 'PreferredHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.9;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 3;
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{ a}, 'InvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.9;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 1;
                    
                                        elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.9;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 2;
                    
                                             
                                         %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                                        %should use 'L' in front of each muscle    
                                         elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb') && strcmp( HoppingRate_ID{b}, 'TwoHz')
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 1.9;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 2;
                    
                                             
                                             
                                      
                                         %For the Control group, tell the code that the MuscleID should use 'L' in front
                                        %of each muscle for the LeftLimb
                                        else
                    
                                             %Set the between-limb morphology
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = 0.55;
                                             
                                             %Set theVAS rating
                                            JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = 0;
                    
                                         %End the if statement for setting the muscle list   
                                         end     
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 1; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 2; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = AnkleSpringIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 1; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 3; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = AnkleMotorIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 1; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 4; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = AnkleDamperIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 2; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 1; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = KneeStrutIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 2; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 2; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = KneeSpringIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 2; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 3; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = KneeMotorIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 2; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 4; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = KneeDamperIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
    
    
    
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 3; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 1; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = HipStrutIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 3; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 2; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = HipSpringIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 3; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 3; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = HipMotorIndex(z);%Hop number            
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
    
    
    
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 1) = m;%Group ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 2) = n;%Participant ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 3) = a;%Limb ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 4) = HoppingRate_ID_forTable(b);%Hopping Rate ID
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 5) = q;%Hopping Bout Number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 6) = 3; %Joint ID. 1 = ankle, 2 = knee, 3 = hip
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 7) = 4; %IndexNumber. 1 = strut, 2 = spring, 3 = motor, 4 = damper
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 8) = z;%Hop number
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 9) = HipDamperIndex(z);%Hip damper value                
                                         %Set the between-limb morphology
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 10)  = NaN;
                                         
                                         %Set theVAS rating
                                        JointBehaviorIndex(RowstoFill_JointBehaviorIndex, 11)  = NaN;
    
    
                                        RowstoFill_JointBehaviorIndex = RowstoFill_JointBehaviorIndex+1;
    
                                    end

%% End Z Loop - Filling Joint Behavior Index
                                end
                                
                                
          %% Plot Work Loops                      

%                                 string_Angle = sprintf('Angle (%c)',char(176));
% 
%                                figure('Color','w','Position', [-1679 31 1680 999],'Name',['Work Loop  ' ParticipantList{n} '  ' LimbID{a} '  '  ' _ ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q}],'Visible',"on"  )
%                                sgtitle(['Work Loop  ' ParticipantList{n} '  ' LimbID{a} '  '  '  ' HoppingTrialNumber{q}])
% 
% 
%                                 subplot(3,1,1)                     
%                                 for s = 1:numel(GContactBegin_FrameNumbers(:,q))
% 
%                                     plot(AnkleAngleSagittal_IndividualHopsContactPhase(1:DesiredLengthofWorkData(s),s),AnkleWork_EntireContactPhase_InterpolatedforWorkLoop(1:DesiredLengthofWorkData(s),s),'LineWidth',2,'Marker','x','MarkerSize',15,'MarkerFrames',1,'MarkerFaceColor','m')
%                                     hold on
%                                     set(gca,'FontSize',12)
%                                     xlabel({string_Angle; '[- = PF/+ = DF]'},'FontSize',14)
%                                     ylabel({'Joint Work  (J/kg)';'';  '[- = Absorb/+ = Generat.]'},'FontSize',14)
%                                     title('Ankle Work Loop','FontSize',16)
%                                     if s == numel(GContactBegin_FrameNumbers(:,q))
%                                         L2 = line([min(min(AnkleAngleSagittal_IndividualHopsContactPhase)) max(max(AnkleAngleSagittal_IndividualHopsContactPhase))],[0 0]);
%                                         L2.LineWidth = 1.2;
%                                         L2.Color = 'k';
%                                         hold off
%                                         legend('Location','bestoutside','FontSize',12)
%                                     end
%                                     xlim([min(min(AnkleAngleSagittal_IndividualHopsContactPhase)) max(max(AnkleAngleSagittal_IndividualHopsContactPhase))])
% 
%                                 end
% 
% 
% 
%                                 subplot(3,1,2)
%                                 for s = 1:numel(GContactBegin_FrameNumbers(:,q))
% 
%                                     plot(KneeAngleSagittal_IndividualHopsContactPhase(1:DesiredLengthofWorkData(s),s),KneeWork_EntireContactPhase_InterpolatedforWorkLoop(1:DesiredLengthofWorkData(s),s),'LineWidth',2,'Marker','x','MarkerSize',15,'MarkerFrames',1,'MarkerFaceColor','#D95319')
%                                     hold on
%                                     set(gca,'FontSize',12)
%                                     xlabel({string_Angle; '[- = Ext/+ = Flex]'},'FontSize',14)
%                                     ylabel({'Joint Work  (J/kg)';'';  '[- = Absorb/+ = Generat.]'},'FontSize',14)
%                                     title('Knee Work Loop','FontSize',16)
%                                      if s == numel(GContactBegin_FrameNumbers(:,q))
%                                         L2 = line([min(min(KneeAngleSagittal_IndividualHopsContactPhase)) max(max(KneeAngleSagittal_IndividualHopsContactPhase))],[0 0]);
%                                         L2.LineWidth = 1.2;
%                                         L2.Color = 'k';
%                                         hold off
%                                         legend('Location','bestoutside','FontSize',12)
%                                      end
%                                     xlim([min(min(KneeAngleSagittal_IndividualHopsContactPhase)) max(max(KneeAngleSagittal_IndividualHopsContactPhase))])
% 
%                                 end
% 
% 
%                                 subplot(3,1,3)   
%                                 for s = 1:numel(GContactBegin_FrameNumbers(:,q))
% 
%                                     plot(HipAngleSagittal_IndividualHopsContactPhase(1:DesiredLengthofWorkData(s),s),HipWork_EntireContactPhase_InterpolatedforWorkLoop(1:DesiredLengthofWorkData(s),s),'LineWidth',2,'Marker','x','MarkerSize',15,'MarkerFrames',1,'MarkerFaceColor','#7E2F8E')
%                                     hold on
%                                     set(gca,'FontSize',12)
%                                     xlabel({string_Angle; '[- = Ext/+ = Flex]'},'FontSize',14)
%                                     ylabel({'Joint Work  (J/kg)';'';  '[- = Absorb/+ = Generat.]'},'FontSize',14)
%                                     title('Hip Work Loop','FontSize',16)
%                                      if s == numel(GContactBegin_FrameNumbers(:,q))
%                                         L2 = line([min(min(HipAngleSagittal_IndividualHopsContactPhase)) max(max(HipAngleSagittal_IndividualHopsContactPhase))],[0 0]);
%                                         L2.LineWidth = 1.2;
%                                         L2.Color = 'k';
%                                         hold off
%                                         legend('Location','bestoutside','FontSize',12)
%                                      end
%                                     xlim([min(min(HipAngleSagittal_IndividualHopsContactPhase)) max(max(HipAngleSagittal_IndividualHopsContactPhase))])
% 
%                                 end
% 
% 
%                                 %pause

%                                 close all





                                    close all


%% Store FrameofMinL5S1Position

                                %In MoCap Samp Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b}, 'FrameofMinL5S1Position_EndBraking_MoCapSampHz', FrameofMinL5S1Position_EndBraking);
                                    
                                %GRF Samp Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b}, 'FrameofMinL5S1Position_EndBraking_GRFSampHz', FrameofMinL5S1Position_EndBraking_GRFSampHz);    

                                
                                %EMG Samp Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b}, 'FrameofMinL5S1Position_EndBraking_EMGSampHz', FrameofMinL5S1Position_EndBraking_GRFSampHz); 




                                %In MoCap Samp Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b}, 'FrameofMinL5S1Position_BeginPropulsion_MoCapSampHz', FrameofMinL5S1Position_BeginPropulsion);
                                    
                                %GRF Samp Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b}, 'FrameofMinL5S1Position_BeginPropulsion_GRFSampHz', FrameofMinL5S1Position_BeginPropulsion_GRFSampHz);    

                                
                                %EMG Samp Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b}, 'FrameofMinL5S1Position_BeginPropulsion_EMGSampHz', FrameofMinL5S1Position_BeginPropulsion_GRFSampHz); 
                                





%% Store Phase Durations (Nontruncated) in Data Structure

                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'PhaseDurations_Nontruncated',HoppingRate_ID{b},HoppingTrialNumber{q},'LengthofContactPhase_sc',LengthofContactPhase_Seconds);

                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'PhaseDurations_Nontruncated',HoppingRate_ID{b},HoppingTrialNumber{q},'LengthofFlightPhase_sec',LengthofFlightPhase_Seconds);

                             David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'PhaseDurations_Nontruncated',HoppingRate_ID{b},HoppingTrialNumber{q},'LengthofBrakingPhase_sec',LengthofBrakingPhase_Seconds); 


                             David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'PhaseDurations_Nontruncated',HoppingRate_ID{b},HoppingTrialNumber{q},'LengthofPropulsionPhase_sec',LengthofPropulsionPhase_Seconds); 




        %% Store Total Negative and Positive Power in Data Structure          

                                %Negative Power Variables
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','TotalNegativePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},TotalNegativePower_AllJoints_EntireContactPhase);


                                %Positive Power Variables
                                 David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','TotalPositivePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},TotalPositivePower_AllJoints_EntireContactPhase);


        %% *Store CoM Vertical Position in Data Structure*                        
                                
                                %Cannot compute CoM position for HP02 - hopping was
                                %collected with US, so one shank doesn't have markers
                                if ~strcmp( ParticipantList{ n }, 'HP02' )
                                            
                                    David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                        'CoM_Vertical_Position', HoppingRate_ID{b}, HoppingTrialNumber{q}, CoMVerticalPosition_IndividualHopsContactPhase);
                                
                                end
                                


        %% *Store L5-S1 Vertical Position in Data Structure*                        
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'L5S1_Vertical_Position_ContactPhase', HoppingRate_ID{b}, HoppingTrialNumber{q}, L5S1VerticalPosition_IndividualHopsContactPhase);




        %%  *Store Ankle Data in Data Structure*

                                %Ankle Power, Individual Hops
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','Power',HoppingRate_ID{b},HoppingTrialNumber{q},AnklePowerSagittal_IndividualHops);

                                %Ankle Power, Individual Hops, Contact Phase
                                 David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','Power_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},AnklePowerSagittal_IndividualHopsContactPhase);

                                %Ankle Work, Individual Hops                       
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','Work_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q}, AnkleWork_EntireContactPhase_InterpolatedforWorkLoop);





                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','PercentNegativePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},PercentNegativePower_Ankle_EntireContactPhase);





                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Sagittal','PercentPositivePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},PercentPositivePower_Ankle_EntireContactPhase);



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Strut_Index',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleStrutIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Spring_Index',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleSpringIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Motor_Index',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleMotorIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Ankle','Damper_Index',HoppingRate_ID{b},HoppingTrialNumber{q},AnkleDamperIndex);

                                
                                
                                
                                

        %% Store Knee Data in Data Structure

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','Power',HoppingRate_ID{b},HoppingTrialNumber{q},KneePowerSagittal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','Power_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},KneePowerSagittal_IndividualHopsContactPhase);

                                
                                
                                %Knee Work, Individual Hops
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','Work_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q}, KneeWork_EntireContactPhase_InterpolatedforWorkLoop);






                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','PercentNegativePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},PercentNegativePower_Knee_EntireContactPhase);




                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Sagittal','PercentPositivePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},PercentPositivePower_Knee_EntireContactPhase);

                                
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Strut_Index',HoppingRate_ID{b},HoppingTrialNumber{q},KneeStrutIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Spring_Index',HoppingRate_ID{b},HoppingTrialNumber{q},KneeSpringIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Motor_Index',HoppingRate_ID{b},HoppingTrialNumber{q},KneeMotorIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Knee','Damper_Index',HoppingRate_ID{b},HoppingTrialNumber{q},KneeDamperIndex);
                                
                                
                                
                                
                                
        %%  Store Hip Data in Data Structure

                               David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','Power',HoppingRate_ID{b},HoppingTrialNumber{q},HipPowerSagittal_IndividualHops);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','Power_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},HipPowerSagittal_IndividualHopsContactPhase);

                                %Hip Work, Individual Hops
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','Work_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q}, HipWork_EntireContactPhase_InterpolatedforWorkLoop);




                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','PercentNegativePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},PercentNegativePower_Hip_EntireContactPhase);






                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Sagittal','PercentPositivePower_EntireContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},PercentPositivePower_Hip_EntireContactPhase);


                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Strut_Index',HoppingRate_ID{b},HoppingTrialNumber{q},HipStrutIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Spring_Index',HoppingRate_ID{b},HoppingTrialNumber{q},HipSpringIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Motor_Index',HoppingRate_ID{b},HoppingTrialNumber{q},HipMotorIndex);
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'IndividualHops',LimbID{a},...
                                    'Hip','Damper_Index',HoppingRate_ID{b},HoppingTrialNumber{q},HipDamperIndex);
                                
                                
                                
                                
    %% END Q Loop - Hopping Bout

                            end

                            
                                
                                

                                
 %% END B Loop - Hopping Rate                       
                            
                        end

                    
%% END A Loop - Limb                
                    
            end

            end%END IF STATEMENT FOR REPROCESSING EACH PARTICIPANT'S DATA
            
%% END N Loop - Participant          
            
        end
        
  
        
        
        
%% END M Loop - Group        
        
    end
    
    

    
    
    
    
    
    
    
    
    
%% END L Loop

end


if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end










 %% !!SECTION 5 - Take Participant/Group Averages for Each Hopping Rate (Average of Joint Power and Behavior Index Matrices)
  

Power_EntireContactPhase(:, 8) = round( Power_EntireContactPhase(:, 8), 1 );
 JointBehaviorIndex( :, 4 ) = round(  JointBehaviorIndex(:, 4), 1 );

    %Will use these to know which row to fill in the joint power and joint behavior index means
    RowtoFill_JointPower = 1;
    RowtoFill_JointPower_ParticipantMeans = 1;
    RowtoFill_JointBehaviorIndex_GroupMeans = 1;
    RowtoFill_JointBehaviorIndex_ParticipantMeans = 1;


    %Need to know how many SD columns we need for Power_EntireContactPhase
    NumberofSD_Columns_PowerTable =  size( Power_EntireContactPhase, 2 ) - 8 ;
    %Create a vector for filling in the SD columns
    ColumntoFill_SD_PowerTable = ( size( Power_EntireContactPhase, 2 ) + 1 ) : ( size( Power_EntireContactPhase, 2 ) + NumberofSD_Columns_PowerTable ) ;



    %Need to know how many SD columns we need for Power_EntireContactPhase
    NumberofSD_Columns_JointBehaviorTable =  size( JointBehaviorIndex, 2 ) - 10;
    %Create a vector for filling in the SD columns
    ColumntoFill_SD_JointBehaviorTable = ( size( JointBehaviorIndex, 2 ) + 1 ) : ( size( JointBehaviorIndex, 2 ) + NumberofSD_Columns_JointBehaviorTable ) ;


    %Initialize matrices to hold joint power and joint behavior index means
    JointPower_GroupMeansPerHoppingRate = NaN( 1,  size( Power_EntireContactPhase, 2 ) + NumberofSD_Columns_PowerTable ); 
    JointPower_ParticipantMeansPerHoppingRate = NaN( 1,  size( Power_EntireContactPhase, 2 ) + NumberofSD_Columns_PowerTable ); 

    JointBehaviorIndex_GroupMeansPerHoppingRate = NaN( 1, size( JointBehaviorIndex, 2 ) + NumberofSD_Columns_JointBehaviorTable );
    JointBehaviorIndex_ParticipantMeansPerHoppingRate = NaN( 1, size( JointBehaviorIndex, 2 ) + NumberofSD_Columns_JointBehaviorTable );
    
    

%Begin M For Loop - Loop Through Groups    
for m = 1:numel(GroupList)

    %Use get field to create a new data structure containing the list of participants. List of participants is
    %stored under the second field of the structure (the list of groups)


    %Need to know which rows in the 1st column of Power_EntireContactPhase correspond to the Mth
    %group
    Power_IndicesForOneGroup = find( Power_EntireContactPhase(:, 1) == m );

    %Create a new joint power matrix containing only Group M
    Power_OneGroup = Power_EntireContactPhase( Power_IndicesForOneGroup, :);


    %Need to know which rows in the 1st column of JointBehaviorIndex correspond to the Mth
    %group
     JointBehaviorIndex_IndicesForOneGroup = find(  JointBehaviorIndex( :, 1 ) == m );


     %Create a new joint behavior index matrix containing only Group M
     JointBehaviorIndex_OneGroup = JointBehaviorIndex( JointBehaviorIndex_IndicesForOneGroup, : );






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
        
        LimbID = [1, 2];

    end





%% Begin A For Loop - Loop Through Limbs

    for a = 1:numel(LimbID)


        %Need to know which rows in the 3rd column of Power_OneGroup correspond to Limb A
        Power_IndicesForOneLimb = find( Power_OneGroup(:, 3) == a );


        %Create a new joint power matrix containing only Limb A
        Power_OneLimb = Power_OneGroup( Power_IndicesForOneLimb, :);


        %Need to know which rows in the 3rd column of JointBehaviorIndex_OneGroup correspond to Limb A
         JointBehaviorIndex_IndicesForOneLimb = find(  JointBehaviorIndex_OneGroup( :, 3 ) == a );


         %Create a new joint behavior index matrix containing only Limb A
         JointBehaviorIndex_OneLimb = JointBehaviorIndex_OneGroup( JointBehaviorIndex_IndicesForOneLimb, : );


%% Begin B For Loop - Loop Through Hopping Rates      

            for b = 1 : numel( HoppingRate_ID)



                %Need to know which rows in the 14th column of Power_OneLimb correspond
                %to Hopping Rate B
                Power_IndicesforOneRate = find( Power_OneLimb( :, 8) == HoppingRate_ID_forTable(b) );

                %Create a new joint power matrix containing only Hopping Rate B
                Power_OneRate = Power_OneLimb( Power_IndicesforOneRate, : );



                %Need to know which rows in the 4th column of JointBehaviorIndex_OneLimb correspond
                %to Hopping Rate B
                 JointBehaviorIndex__IndicesforOneRate = find( JointBehaviorIndex_OneLimb(:, 4) == round(HoppingRate_ID_forTable(b) ));

                 %Create a new joint behavior index matrix containing only Hopping Rate B
                 JointBehaviorIndex_OneRate = JointBehaviorIndex_OneLimb( JointBehaviorIndex__IndicesforOneRate, :);


                %Need to create a vector containing the values  for  each joint (1 for ankle, 2 for knee, 3
                %for hip )
                VectorofUniqueJoints = unique( Power_OneRate( :, 7 ) );




%% Begin C For Loop - Loop Through Each Joint

                for c = 1 : length( VectorofUniqueJoints ) 

                    

                    %Need to know which rows in the 7th column of Power_OneRate
                    %correspond to Joint C
                    Power_IndicesforOneJoint = find( Power_OneRate( :, 7 ) == VectorofUniqueJoints( c ) );

                    %Create a new joint power matrix containing only Joint C
                    Power_OneJoint = Power_OneRate( Power_IndicesforOneJoint, : );



                    %Need to know which rows in the 6th column of  JointBehaviorIndex_OneRate
                    %correspond to Joint C
                    JointBehaviorIndex_IndicesforOneJoint = find(  JointBehaviorIndex_OneRate( :, 6 ) == VectorofUniqueJoints( c ) );


                    %Create a new joint behavior index matrix containing only Joint C
                    JointBehaviorIndex_OneJoint =  JointBehaviorIndex_OneRate( JointBehaviorIndex_IndicesforOneJoint, : );





                    %We want to take average of participant data, so fist create a vector containing
                    %Participant IDs. Use unique() to get rid of repeating IDs.
                    VectorofUniqueParticipants = unique( Power_OneJoint( :, 2 ) );



%% Calculate Group Means - Joint Power

                    %Take average of each column of Power_OneJoint and store in the next row of JointPower_GroupMeansPerHoppingRate
                    JointPower_GroupMeansPerHoppingRate( RowtoFill_JointPower, 1 : size( Power_EntireContactPhase, 2) ) = mean(  Power_OneJoint, 1, 'omitnan'  );

                    for z = 1 : numel( ColumntoFill_SD_PowerTable )

                        %Find standard deviation of each power variable
                        JointPower_GroupMeansPerHoppingRate( RowtoFill_JointPower, ColumntoFill_SD_PowerTable(z) ) =...
                            std(  Power_OneJoint( :, ColumntoFill_SD_PowerTable( z ) -NumberofSD_Columns_PowerTable  ), 'omitnan'  );

                    end

                    %Add 1 to RowtoFill_JointPower  so the next loop will fill the next row of JointPower_GroupMeansPerHoppingRate
                    RowtoFill_JointPower =  RowtoFill_JointPower + 1;
                    



%% Begin E For Loop - Loop Through Participants
                    for e = 1 : numel( VectorofUniqueParticipants )
                    
                        %Find which rows in the 2nd column of Power_OneJoint correspond to Participant E
                        Power_IndicesforOneParticipant = find( Power_OneJoint( :, 2 ) == VectorofUniqueParticipants( e ) );
                    
                        %Create a new joint power matrix containing only Participant E
                        Power_OneParticipant = Power_OneJoint( Power_IndicesforOneParticipant, : );


%% Calculate Participant Means - Joint Power

                        %Find the mean of all columns of Power_OneParticipant and store in the same
                        %columns in JointPower_ParticipantMeansPerHoppingRate
                        JointPower_ParticipantMeansPerHoppingRate( RowtoFill_JointPower_ParticipantMeans, 1 : size( Power_EntireContactPhase, 2) ) = mean(  Power_OneParticipant, 1, 'omitnan'  );
                        
                        %Use this for loop to calculate the SD of each numerical variable in
                        %Power_EntireContactPhase and store in the next column of
                        %JointPower_ParticipantMeansPerHoppingRate. Find the column in
                        %Power_OneParticipant by subtracting the total number of SD columns from the
                        %ColumntoFill_SD variable.
                        for z = 1 : numel( ColumntoFill_SD_PowerTable )

                            %Find standard deviation of each power variable
                            JointPower_ParticipantMeansPerHoppingRate( RowtoFill_JointPower_ParticipantMeans, ColumntoFill_SD_PowerTable(z) ) =...
                                std(  Power_OneParticipant( :, ColumntoFill_SD_PowerTable( z ) - NumberofSD_Columns_PowerTable ), 'omitnan'  );
                        
                        end
                       
                        %Add 1 to RowtoFill_JointPower_ParticipantMeans so that the next loop fills in
                        %the next row of JointPower_ParticipantMeansPerHoppingRate
                       RowtoFill_JointPower_ParticipantMeans = RowtoFill_JointPower_ParticipantMeans + 1;



                        %Need to know which rows in the 2nd column of  JointBehaviorIndex_OneJoint
                        %correspond to Participant E
                        JointBehaviorIndex_IndicesforOneParticipant = find(  JointBehaviorIndex_OneJoint( :, 2 ) == VectorofUniqueParticipants( e ) );
    
    
                        %Create a new joint behavior index matrix containing only Participant E
                        JointBehaviorIndex_OneParticipant =  JointBehaviorIndex_OneJoint( JointBehaviorIndex_IndicesforOneParticipant, : );




                        %Need to create a vector containing the values  for  each joint behavior index (1 for strut, 2 for spring, 3
                        %for motor, 4 for brake/damper)
                        VectorofUniqueJointBehaviors = unique( JointBehaviorIndex_OneParticipant( :, 7 ) );





%% Begin D For Loop - Loop Through Joint Behavior Indices      
                        for d = 1 : length( VectorofUniqueJointBehaviors )









                            %Need to know which rows in the 7th column of  JointBehaviorIndex_OneJoint
                            %correspond to Behavior Index D
                            JointBehaviorIndex_IndicesforOneBehavior_ParticipantMeans = find( JointBehaviorIndex_OneParticipant( :, 7 ) == VectorofUniqueJointBehaviors(d) );
    
    
    
                            %Create a new joint behavior index matrix containing only Behavior Index D
                           JointBehaviorIndex_OneBehavior_ParticipantMeans = JointBehaviorIndex_OneParticipant( JointBehaviorIndex_IndicesforOneBehavior_ParticipantMeans, : );


%% Calculate Participant Means - Functional Index
    
                            %Take average of each column of Power_OneJoint and store in the next row of JointBehaviorIndex_OneBehavior 
                            JointBehaviorIndex_ParticipantMeansPerHoppingRate( RowtoFill_JointBehaviorIndex_ParticipantMeans, 1 : size( JointBehaviorIndex, 2 ) ) =...
                                mean( JointBehaviorIndex_OneBehavior_ParticipantMeans, 1, 'omitnan' );
                            

                            for z = 1 : numel( ColumntoFill_SD_JointBehaviorTable )

                                %Find standard deviation of joint behavior index variable
                                JointBehaviorIndex_ParticipantMeansPerHoppingRate( RowtoFill_JointBehaviorIndex_ParticipantMeans,  ColumntoFill_SD_JointBehaviorTable( z ) ) =...
                                    std( JointBehaviorIndex_OneBehavior_ParticipantMeans(:, ColumntoFill_SD_JointBehaviorTable( z ) - NumberofSD_Columns_JointBehaviorTable ), 'omitnan' );%Hop number
                            
                            end
                            

                            %Add 1 to  RowtoFill_JointBehaviorIndex_ParticipantMeans  so the next loop will fill the next row of JointBehaviorIndex_ParticipantMeansPerHoppingRate
                            RowtoFill_JointBehaviorIndex_ParticipantMeans = RowtoFill_JointBehaviorIndex_ParticipantMeans + 1;



    


                        
                        end%End D Loop - Each Joint Behavior

                       
                    end%End E Loop - Each Participant
                    
                    
                        
%% Begin D For Loop - Loop Through Joint Behavior Indices      
                    for d = 1 : length( VectorofUniqueJointBehaviors )



                        %Need to know which rows in the 7th column of  JointBehaviorIndex_OneJoint
                        %correspond to Behavior Index D
                        JointBehaviorIndex_IndicesforOneBehavior_GroupMeans = find( JointBehaviorIndex_OneJoint( :, 7 ) == VectorofUniqueJointBehaviors(d) );


                        %Create a new joint behavior index matrix containing only Behavior Index D
                       JointBehaviorIndex_OneBehavior_GroupMeans = JointBehaviorIndex_OneJoint( JointBehaviorIndex_IndicesforOneBehavior_GroupMeans, : );



%% Calculate Group Means - Joint Power                       

                        %Take average of each column of Power_OneJoint and store in the next row of JointBehaviorIndex_OneBehavior 
                        JointBehaviorIndex_GroupMeansPerHoppingRate( RowtoFill_JointBehaviorIndex_GroupMeans, 1 : size( JointBehaviorIndex, 2 ) ) =...
                            mean( JointBehaviorIndex_OneBehavior_GroupMeans, 1, 'omitnan' );
                            

                        for z = 1 : numel( ColumntoFill_SD_JointBehaviorTable )
                        
                            %Find standard deviation of joint behavior index variable
                            JointBehaviorIndex_GroupMeansPerHoppingRate(RowtoFill_JointBehaviorIndex_GroupMeans,  ColumntoFill_SD_JointBehaviorTable( z )  ) =...
                                std( JointBehaviorIndex_OneBehavior_GroupMeans( :, ColumntoFill_SD_JointBehaviorTable( z ) - NumberofSD_Columns_JointBehaviorTable ), 'omitnan' );%Hop number
                            
                        end


                        
                        %Add 1 to  RowtoFill_JointBehaviorIndex  so the next loop will fill the next row of JointBehaviorIndex_GroupMeansPerHoppingRate
                        RowtoFill_JointBehaviorIndex_GroupMeans = RowtoFill_JointBehaviorIndex_GroupMeans + 1;






                        
                    end%End D Loop - Each Joint Behavior
                    
                    
                end%End C Loop - Each Joint
                
                
            end%End B Loop - Hopping Rate
            
            
    end%End A Loop - Limb ID
    
end%End M Loop - Group ID
    
    

if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 5',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end








  %% !!SECTION 6 - Find Between-Limb Diff, Use Participant Means
  

JointPower_ParticipantMeansPerHoppingRate(:,8) = round( JointPower_ParticipantMeansPerHoppingRate(:,8) , 1 );

JointBehaviorIndex_ParticipantMeansPerHoppingRate(:,4) = round( JointBehaviorIndex_ParticipantMeansPerHoppingRate(:,4) , 1 );


    %Will use these to know which row to fill in the joint power and joint behavior index means
    RowtoFill_JointPower_LimbDiff = 1;
    RowtoFill_JointBehaviorIndex_LimbDiff = 1;
    

    %Initialize matrices to hold joint power and joint behavior index means
    JointPower_ParticipantMeansLimbDiff = NaN( 1,  50 ); 
    JointBehaviorIndex_ParticipantMeansLimbDiff = NaN( 1,  12 ); 
  
    
    

%Begin M For Loop - Loop Through Groups    
for m = 1:numel(GroupList)

    %Use get field to create a new data structure containing the list of participants. List of participants is
    %stored under the second field of the structure (the list of groups)


    %Need to know which rows in the 1st column of Power_EntireContactPhase correspond to the Mth
    %group
    Power_IndicesForOneGroup = find( JointPower_ParticipantMeansPerHoppingRate(:, 1) == m );

    %Create a new joint power matrix containing only Group M
    Power_OneGroup = JointPower_ParticipantMeansPerHoppingRate( Power_IndicesForOneGroup, :);





    %Need to know which rows in the 1st column of JointBehaviorIndex correspond to the Mth
    %group
     JointBehaviorIndex_IndicesForOneGroup = find(  JointBehaviorIndex_ParticipantMeansPerHoppingRate( :, 1 ) == m );


     %Create a new joint behavior index matrix containing only Group M
     JointBehaviorIndex_OneGroup = JointBehaviorIndex_ParticipantMeansPerHoppingRate( JointBehaviorIndex_IndicesForOneGroup, : );






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
        
        LimbID = [1, 2];

    end





%% Begin B For Loop - Loop Through Hopping Rates      

            for b = 1 : numel( HoppingRate_ID)



                %Need to know which rows in the 14th column of Power_OneLimb correspond
                %to Hopping Rate B
                Power_IndicesforOneRate = find( Power_OneGroup( :, 8) == round(HoppingRate_ID_forTable(b), 1 ) );

                %Create a new joint power matrix containing only Hopping Rate B
                Power_OneRate = Power_OneGroup( Power_IndicesforOneRate, : );



                %Need to know which rows in the 4th column of JointBehaviorIndex_OneLimb correspond
                %to Hopping Rate B
                 JointBehaviorIndex__IndicesforOneRate = find( JointBehaviorIndex_OneGroup(:, 4) == round(HoppingRate_ID_forTable(b) ));

                 %Create a new joint behavior index matrix containing only Hopping Rate B
                 JointBehaviorIndex_OneRate = JointBehaviorIndex_OneGroup( JointBehaviorIndex__IndicesforOneRate, :);


                %Need to create a vector containing the values  for  each joint (1 for ankle, 2 for knee, 3
                %for hip )
                VectorofUniqueJoints = unique( Power_OneRate( :, 7 ) );




%% Begin C For Loop - Loop Through Each Joint

                for c = 1 : length( VectorofUniqueJoints ) 

                    

                    %Need to know which rows in the 7th column of Power_OneRate
                    %correspond to Joint C
                    Power_IndicesforOneJoint = find( Power_OneRate( :, 7 ) == VectorofUniqueJoints( c ) );

                    %Create a new joint power matrix containing only Joint C
                    Power_OneJoint = Power_OneRate( Power_IndicesforOneJoint, : );



                    %Need to know which rows in the 6th column of  JointBehaviorIndex_OneRate
                    %correspond to Joint C
                    JointBehaviorIndex_IndicesforOneJoint = find(  JointBehaviorIndex_OneRate( :, 6 ) == VectorofUniqueJoints( c ) );


                    %Create a new joint behavior index matrix containing only Joint C
                    JointBehaviorIndex_OneJoint =  JointBehaviorIndex_OneRate( JointBehaviorIndex_IndicesforOneJoint, : );


                    %Need to create a vector containing the values  for  each joint behavior index (1 for strut, 2 for spring, 3
                    %for motor, 4 for brake/damper)
                    VectorofUniqueJointBehaviors = unique( JointBehaviorIndex_OneJoint( :, 7 ) );

                    %We want to take average of participant data, so fist create a vector containing
                    %Participant IDs. Use unique() to get rid of repeating IDs.
                    VectorofUniqueParticipants = unique( Power_OneJoint( :, 2 ) );





                    
%% Begin E For Loop - Loop Through Participants
                    for e = 1 : numel( VectorofUniqueParticipants )
                    
                    
%% Joint Power Calculations

                        Power_IndicesforOneParticipant = find( Power_OneJoint( :, 2 ) == VectorofUniqueParticipants( e ) );
                    
                        %Create a new joint power matrix containing only Participant E
                        Power_OneParticipant = Power_OneJoint( Power_IndicesforOneParticipant, : );

                        %Store Group_ID, Participant_ID, Joint_ID, HoppingRate_ID in the first 4 columns
                        %of JointPower_ParticipantMeansLimbDiff
                        JointPower_ParticipantMeansLimbDiff( RowtoFill_JointPower_LimbDiff, 1 : 4 ) = Power_OneParticipant(1, [ 1, 2, 7, 8 ] );
                        


                        %Use this for loop to calculate the between-limb diff in the numerical variables
                        %of Power_OneParticipant, which is from column 9 onward.
                        for z = 9 : size( Power_OneParticipant, 2 )

                            if z == 90

                                %Calculate between-limb diff as either Non-Involved Minus Involved or
                                %Contralateral Minus Matched Dominance
                                JointPower_ParticipantMeansLimbDiff( RowtoFill_JointPower_LimbDiff, z - 4 ) = Power_OneParticipant( 1, z );
    
    
                                %Calculate between-limb diff as either Non-Involved Minus Involved or
                                %Contralateral Minus Matched Dominance
                                JointPower_ParticipantMeansLimbDiff( RowtoFill_JointPower_LimbDiff, size( Power_OneParticipant, 2 ) + z - 12  ) = Power_OneParticipant( 1, z );

                            else

                                %Calculate between-limb diff as either Non-Involved Minus Involved or
                                %Contralateral Minus Matched Dominance
                                JointPower_ParticipantMeansLimbDiff( RowtoFill_JointPower_LimbDiff, z - 4 ) = Power_OneParticipant( 2, z ) - Power_OneParticipant( 1, z );
    
    
                                %Calculate between-limb diff as either Non-Involved Minus Involved or
                                %Contralateral Minus Matched Dominance
                                JointPower_ParticipantMeansLimbDiff( RowtoFill_JointPower_LimbDiff, size( Power_OneParticipant, 2 ) + z - 12  ) = Power_OneParticipant( 1, z ) ./ Power_OneParticipant( 2, z );

                            end

                        
                        end
                       
                       RowtoFill_JointPower_LimbDiff = RowtoFill_JointPower_LimbDiff + 1;





                        %Need to know which rows in the 2nd column of  JointBehaviorIndex_OneJoint
                        %correspond to Participant E
                        JointBehaviorIndex_IndicesforOneParticipant_ParticipantMeans = find( JointBehaviorIndex_OneJoint( :, 2 ) == VectorofUniqueParticipants( e ) );



                        %Create a new joint behavior index matrix containing only Behavior Index D
                       JointBehaviorIndex_OneParticipant = JointBehaviorIndex_OneJoint( JointBehaviorIndex_IndicesforOneParticipant_ParticipantMeans, : );





                        %% Begin D For Loop - Loop Through Joint Behavior Indices      
                        for d = 1 : length( VectorofUniqueJointBehaviors )


    

                            %Need to know which rows in the 7th column of  JointBehaviorIndex_OneJoint
                            %correspond to Behavior Index D
                            JointBehaviorIndex_IndicesforOneBehavior_ParticipantMeans = find( JointBehaviorIndex_OneParticipant( :, 7 ) == VectorofUniqueJointBehaviors(d) );
    
    
    
                            %Create a new joint behavior index matrix containing only Behavior Index D
                           JointBehaviorIndex_OneBehavior_ParticipantMeans = JointBehaviorIndex_OneParticipant( JointBehaviorIndex_IndicesforOneBehavior_ParticipantMeans, : );
    

%% Joint Behavior Index Calculations    
                            
                            %Store Group_ID, Participant_ID, HoppingRate_ID, Joint_ID, Index_ID in the first 5 columns
                            %of JointBehaviorIndex_ParticipantMeansLimbDiff
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 1 : 5 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, [ 1, 2, 4, 6, 7 ] );
    

                            %Find between-limb difference of average of functional index value, stored in Column 9 of
                            %JointBehaviorIndex
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 6 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 2, 9 ) -...
                                JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, 9 );

                            %Find between-limb ratio of average of functional index value, stored in Column 9 of
                            %JointBehaviorIndex
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 7 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, 9 ) ./...
                                JointBehaviorIndex_OneBehavior_ParticipantMeans( 2, 9 ) ;
    
                            %Add tendon morphology to column 8
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 8 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, 10 );
    

                            %Add VAS score to column 9 - between-limb diff
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 9 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, 11 ) -...
                                JointBehaviorIndex_OneBehavior_ParticipantMeans( 2, 11 );
    
                            %Add VAS score to column 9 - between-limb ratio
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 10 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, 11 ) ./...
                                JointBehaviorIndex_OneBehavior_ParticipantMeans( 2, 11 );



                            %Find between-limb difference of SD of functional index value, stored in Column 9 of
                            %JointBehaviorIndex
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 11 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 2, 12 ) -...
                                JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, 12 );


                            %Find between-limb ratio of SD of functional index value, stored in Column 9 of
                            %JointBehaviorIndex
                            JointBehaviorIndex_ParticipantMeansLimbDiff( RowtoFill_JointBehaviorIndex_LimbDiff , 12 ) =  JointBehaviorIndex_OneBehavior_ParticipantMeans( 1, 12 ) ./...
                                JointBehaviorIndex_OneBehavior_ParticipantMeans( 2, 12 );


                            
                            
    
                            %Add 1 to  RowtoFill_JointBehaviorIndex  so the next loop will fill the next row of JointBehaviorIndex_ParticipantMeansPerHoppingRate
                            RowtoFill_JointBehaviorIndex_LimbDiff  = RowtoFill_JointBehaviorIndex_LimbDiff  + 1;
    
                            
                        end%End D Loop - Each Joint Behavior
                       
                    end%End E Loop - Each Participant
                    

                    
                end%End C Loop - Each Joint
                
                
            end%End B Loop - Hopping Rate
    
end%End M Loop - Group ID
    
    

if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 6',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end







%% !!SECTION 7 - Create and Export Tables
    




%Set variable names for creaitng tables from the Power_EntireContactPhase
VariableNames_PowerEntireCycle = {'Group_ID','Participant_ID','Limb_ID','MTU_ID','Trial_ID','Hop_ID','Joint_ID', 'HoppingRate_ID',...
    'TotalNegativePower_Joint_EntireContactPhase','TotalPositivePower_Joint_EntireContactPhase',...
    'PercentNegativePower_JointContribution_EntireContactPhase', 'PercentPositivePower_JointContribution_EntireContactPhase',...
    'TotalNegativePower_AllJoints_EntireContactPhase',...
    'TotalPositivePower_AllJoints_EntireContactPhase', ' Total_Joint_Negative_Work_AllPeriodsAcrossContactPhase ', ' Total_Joint_Positive_Work_AllPeriodsAcrossContactPhase ',...
    'Joint_Work_Ratio_AllPeriodsAcrossContactPhase', 'Total_Joint_Work_EntireContactPhase', 'Total_Joint_Torque_Impulse_EntireContactPhase',...
    ' Joint_Percent_MEE_Absorption ', ' Joint_Percent_MEE_Generation ', ' Limb_Absorption_MEE ', ' Limb_Generation_MEE ', 'Joint_Absorption_MEE', 'Joint_Generation_MEE', 'Joint_Absorption_SagittalTorqueImpulse', 'Joint_Generation_SagittalTorqueImpulse',...
     'Peak_Joint_AngularVelocity_Absorption', 'Peak_Joint_AngularVelocity_Generation', 'HoppingHeight_m', 'LimbWorkRatio_BrakingPhase', 'LimbWorkRatio_PropulsionPhase',....
     'JointPercentMEE_ContactPhase', 'WholeLimbMEE_ContactPhase', 'JointMEE_ContactPhase', 'JointTorqueImpulse_ContactPhase',...
     'AnkleandKneeContactMEE', 'AnklePercentMEE_ofAnkleandKneeMEE_Contact', 'KneePercentMEE_ofAnkleandKneeMEE_Contact',...
    'AnkleandKneeBrakingMEE', 'AnklePercentMEE_ofAnkleandKneeMEE_Braking', 'KneePercentMEE_ofAnkleandKneeMEE_Braking',...
    'AnkleandKneePropulsionMEE', 'AnklePercentMEE_ofAnkleandKneeMEE_Propulsion', 'KneePercentMEE_ofAnkleandKneeMEE_Propulsion',...
     'JointFrontalTorqueImpulse_ContactPhase', 'JointTransverseTorqueImpulse_ContactPhase',...
     'Joint_Absorption_FrontalTorqueImpulse', 'Joint_Generation_FrontalTorqueImpulse',...
     'Joint_Absorption_TransverseTorqueImpulse', 'Joint_Generation_TransverseTorqueImpulse',...
     'SagittalRoM_BrakingPhase', 'SagittalRoM_PropulsionPhase',...
     'LengthofFlightPhase_sec', 'LengthofContactPhase_sec', 'LengthofBrakingPhase_sec', 'LengthofPropulsionPhase_sec',...
    'AverageJointAngVel_BrakingPhase', 'AverageJointAngVel_PropulsionPhase',...
    'TimetoPeakJointFlexion_BrakingPhase', 'TimetoPeakJointExtension_PropulsionPhase',...
    'TimetoPeakJointFlexionAngVel_BrakingPhase', 'TimetoPeakJointExtensionAngVel_PropulsionPhase', 'JointAngleAtPeakAngVel_BrakingPhase', 'JointAngleAtPeakAngVel_PropulsionPhase',...
    'PeakJointAngle_BrakingPhase', 'PeakJointAngle_PropulsionPhase',...
    'LengthofHopCycle_sec', 'HopFrequency',...
    'JointInitialContactAngle', 'JointInitialPropulsionPhaseAngle', 'JointAverageBrakingTorque', 'JointAveragePropulsionTorque',...
    'TotalLimbSupportMoment_BrakingPhase','TotalJointSupportMoment_BrakingPhase','JointContribution_SupportMoment_BrakingPhase',...
    'JointContribution_PeakSupportMoment_BrakingPhase','PeakSupportMoment_BrakingPhase','TotalLimbSupportPower_BrakingPhase',...
    'TotalJointSupportPower_BrakingPhase','JointContribution_SupportPower_BrakingPhase','TotalLimbSupportMoment_PropulsionPhase',...
    'TotalJointSupportMoment_PropulsionPhase','JointContribution_SupportMoment_PropulsionPhase','JointContribution_PeakSupportMoment_PropulsionPhase',...
    'PeakSupportMoment_PropulsionPhase','TotalLimbSupportPower_PropulsionPhase','TotalJointSupportPower_PropulsionPhase',...
    'JointContribution_SupportPower_PropulsionPhase',...
    'BetweenLimbTendonThickness_mm','VAS_Rating',...
     'JointWork_BrakingPhase', 'JointContribution2LimbWork_BrakingPhase', 'WholeLimbWork_BrakingPhase',...
     'JointWork_PropulsionPhase', 'JointWorkRatio_PropulsionvsBrakingPhase', 'WholeLimbWork_PropulsionPhase',...
     'TotalLimbSupportMoment_Braking_AllNegativeSupportMoment', 'TotalJointSupportMoment_Braking_AllNegativeSupportMoment', 'JointContribution_BrakingPhase_AllNegativeSupportMoment',...
     'TotalLimbSupportPower_Braking_AllNegativeSupportPower', 'TotalJointSupportPower_Braking_AllNegativeSupportPower', 'JointContribution_BrakingPhase_AllNegativeSupportPower',...
     'TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment', 'TotalJointSupportMoment_Propulsion_AllNegativeSupportMoment', 'JointContribution_PropulsionPhase_AllNegativeSupportMoment',...
     'TotalLimbSupportPower_Propulsion_AllPositiveSupportPower', 'TotalJointSupportPower_Propulsion_AllPositiveSupportPower', 'JointContribution_PropulsionPhase_AllPositiveSupportPower',...
     'JointContribution2LimbWork_PropulsionPhase',...
    'TotalLimbSupportMoment_Braking_NoFlexorTorque', 'TotalJointSupportMoment_Braking_NoFlexorTorque', 'JointSupportMomentContribution_Braking_NoFlexorTorque',...
    'TotalLimbSupportMoment_Propulsion_NoFlexorTorque', 'TotalJointSupportMoment_Propulsion_NoFlexorTorque', 'JointSupportMomentContribution_Propulsion_NoFlexorTorque',...
    'JointWork_Braking_GenerationNeutralized', 'WholeLimbWork_Braking_GenerationNeutralized', 'JointWorkContribution_Braking_GenerationNeutralized',...
    'JointWork_Propulsion_AbsorptionNeutralized', 'WholeLimbWork_Propulsion_AbsorptionNeutralized', 'JointWorkContribution_Propulsion_AbsorptionNeutralized',...
    'JointAverageAbsorptionMEE', 'WholeLimbAverageAbsorptionMEE', 'JointContribution_AverageAbsorptionMEE',...
    'JointAverageGenerationMEE', 'WholeLimbAverageGenerationMEE', 'JointContribution_AverageGenerationMEE',...
    'JointAveragePower_Braking_GenerationNeutralized', 'LimbAveragePower_Braking_GenerationNeutralized', 'JointContribution_AveragePower_GenerationNeutralized',...
    'JointAveragePower_Propulsion_AbsorptionNeutralized', 'LimbAveragePower_Propulsion_AbsorptionNeutralized', 'JointContribution_AveragePower_AbsorptionNeutralized',...
    'TotalLimbAverageTorqueImpulse_Braking_Sagittal_NoFlexTorq', 'JointAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq', 'JointContribution_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq',...
    'TotalLimbAverageTorqueImpulse_Propulsion_Sagittal_NoFlexTorq', 'JointAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq', 'JointContribution_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq',...
    'TotalLimbAverageTorqueImpulse_Braking_Frontal_NoFlexTorq', 'JointAverageBrakingTorqueImpulse_Frontal_NoFlexTorq', 'JointContribution_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq',...
    'TotalLimbAverageTorqueImpulse_Propulsion_Frontal_NoFlexTorq', 'JointAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq', 'JointContribution_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq',...
    'TotalLimbAverageTorqueImpulse_Braking_Transverse_NoFlexTorq', 'JointAverageBrakingTorqueImpulse_Transverse_NoFlexTorq', 'JointContribution_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq',...
    'TotalLimbAverageTorqueImpulse_Propulsion_Transverse_NoFlexTorq', 'JointAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq', 'JointContribution_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq' };

%Create a table from the Power_EntireContactPhase dat
Power_EntireContactPhase_Table = array2table(Power_EntireContactPhase, 'VariableNames', VariableNames_PowerEntireCycle);

%Save the Power_EntireContactPhase table as an Excel file
writetable(Power_EntireContactPhase_Table, 'PostQuals_Power_EntireContactPhase_Table.xlsx');

%Save the Power_EntireContactPhase matrix (NOT table) in the data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','AllGroups','Power_EntireContactPhase_Matrix', Power_EntireContactPhase);

%Save the Power_EntireContactPhase table in the data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','AllGroups','Power_EntireContactPhase_Table', Power_EntireContactPhase_Table);









    
%Set variable names for creaitng tables from the JointBehaviorIndex    
JointBehaviorIndex_VariableNames = {'Group_ID','Participant_ID','Limb_ID','HoppingRate_ID','Trial_ID','Joint_ID','Index_ID','Hop_ID','Index_Value',...
    'BetweenLimbTendonThickness_mm','VAS_Rating' };

%Create a table from the JointBehaviorIndex data
JointBehaviorIndex_Table = array2table(  JointBehaviorIndex, 'VariableNames', JointBehaviorIndex_VariableNames );
    
%Save theJointBehaviorIndex table as an Excel file
writetable( JointBehaviorIndex_Table , 'PostQuals_JointFunctionalIndex_Table.xlsx' );
    

%Save the Power_EntireContactPhase matrix (NOT table) in the data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','AllGroups','JointBehaviorIndex_Matrix', JointBehaviorIndex);

%Save the Power_EntireContactPhase table in the data structure
David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','AllGroups','JointBehaviorIndex_Table', JointBehaviorIndex_Table);













%Set variable names for creaitng tables from the JointPower_GroupMeansPerHoppingRate and
%JointPower_ParticipantMeansPerHoppingRate data
VariableNames_PowerEntireCycle = {'Group_ID','Participant_ID','Limb_ID','MTU_ID','Trial_ID','Hop_ID','Joint_ID','HoppingRate_ID',...
    'Mean_TotalNegativePower_Joint_EntireContactPhase',...
    'Mean_TotalPositivePower_Joint_EntireContactPhase', 'Mean_PercentNegativePower_JointContribution_EntireContactPhase', 'Mean_PercentPositivePower_JointContribution_EntireContactPhase',...
    'Mean_TotalNegativePower_AllJoints_EntireContactPhase', 'Mean_TotalPositivePower_AllJoints_EntireContactPhase',...
    ' Mean_Total_Joint_Negative_Work_AllPeriodsAcrossContactPhase ', ' Mean_Total_Joint_Positive_Work_AllPeriodsAcrossContactPhase ', 'Mean_Joint_Work_Ratio_AllPeriodsAcrossContactPhase',...
    'Mean_Total_Joint_Work_EntireContactPhase', 'Mean_Total_Joint_Torque_Impulse_EntireContactPhase', ...
    ' Mean_Joint_Percent_MEE_Absorption ', ' Mean_Joint_Percent_MEE_Generation ', ' Mean_Limb_Absorption_MEE ', ' Mean_Limb_Generation_MEE ', 'Mean_Joint_Absorption_MEE', 'Mean_Joint_Generation_MEE',...
    'Mean_Joint_Absorption_SagittalTorqueImpulse', 'Mean_Joint_Generation_SagittalTorqueImpulse', 'Mean_Peak_Joint_AngularVelocity_Absorption', 'Mean_Peak_Joint_AngularVelocity_Generation',...
    'Mean_HoppingHeight_m', 'Mean_LimbWorkRatio_BrakingPhase', 'Mean_LimbWorkRatio_PropulsionPhase',...
    'Mean_JointPercentMEE_ContactPhase', 'Mean_WholeLimbMEE_ContactPhase', 'Mean_JointMEE_ContactPhase', 'Mean_JointSagittalTorqueImpulse_ContactPhase',...
    'Mean_AnkleandKneeContactMEE', 'Mean_AnklePercentMEE_ofAnkleandKneeMEE_Contact', 'Mean_KneePercentMEE_ofAnkleandKneeMEE_Contact',...
    'Mean_AnkleandKneeBrakingMEE', 'Mean_AnklePercentMEE_ofAnkleandKneeMEE_Braking', 'Mean_KneePercentMEE_ofAnkleandKneeMEE_Braking',...
    'Mean_AnkleandKneePropulsionMEE', 'Mean_AnklePercentMEE_ofAnkleandKneeMEE_Propulsion', 'Mean_KneePercentMEE_ofAnkleandKneeMEE_Propulsion',...
     'Mean_JointFrontalTorqueImpulse_ContactPhase', 'Mean_JointTransverseTorqueImpulse_ContactPhase',...
     'Mean_Joint_Absorption_FrontalTorqueImpulse', 'Mean_Joint_Generation_FrontalTorqueImpulse',...
     'Mean_Joint_Absorption_TransverseTorqueImpulse', 'Mean_Joint_Generation_TransverseTorqueImpulse',...
     'Mean_SagittalRoM_BrakingPhase', 'Mean_SagittalRoM_PropulsionPhase'...,
     'Mean_LengthofFlightPhase_sec', 'Mean_LengthofContactPhase_sec', 'Mean_LengthofBrakingPhase_sec', 'Mean_LengthofPropulsionPhase_sec',...
    'Mean_AverageJointAngVel_BrakingPhase', 'Mean_AverageJointAngVel_PropulsionPhase',...
    'Mean_TimetoPeakJointFlexion_BrakingPhase', 'Mean_TimetoPeakJointExtension_PropulsionPhase',...
    'Mean_TimetoPeakJointFlexionAngVel_BrakingPhase', 'Mean_TimetoPeakJointExtensionAngVel_PropulsionPhase', 'Mean_JointAngleAtPeakAngVel_BrakingPhase', 'Mean_JointAngleAtPeakAngVel_PropulsionPhase',...
    'Mean_PeakJointAngle_BrakingPhase', 'Mean_PeakJointAngle_PropulsionPhase',...
    'Mean_LengthofHopCycle_sec', 'Mean_HopFrequency',...
    'Mean_JointInitialContactAngle', 'Mean_JointInitialPropulsionPhaseAngle', 'Mean_JointAverageBrakingTorque', 'Mean_JointAveragePropulsionTorque',...
    'Mean_TotalLimbSupportMoment_BrakingPhase','Mean_TotalJointSupportMoment_BrakingPhase','Mean_JointContribution_SupportMoment_BrakingPhase',...
    'Mean_JointContribution_PeakSupportMoment_BrakingPhase','Mean_PeakSupportMoment_BrakingPhase','Mean_TotalLimbSupportPower_BrakingPhase',...
    'Mean_TotalJointSupportPower_BrakingPhase','Mean_JointContribution_SupportPower_BrakingPhase','Mean_TotalLimbSupportMoment_PropulsionPhase',...
    'Mean_TotalJointSupportMoment_PropulsionPhase','Mean_JointContribution_SupportMoment_PropulsionPhase','Mean_JointContribution_PeakSupportMoment_PropulsionPhase',...
    'Mean_PeakSupportMoment_PropulsionPhase','Mean_TotalLimbSupportPower_PropulsionPhase','Mean_TotalJointSupportPower_PropulsionPhase',...
    'Mean_JointContribution_SupportPower_PropulsionPhase',...
    'Mean_BetweenLimbTendonThickness_mm','Mean_VAS_Rating',...
     'Mean_JointWork_BrakingPhase', 'Mean_JointContribution2LimbWork_BrakingPhase', 'Mean_WholeLimbWork_BrakingPhase',...
     'Mean_JointWork_PropulsionPhase', 'Mean_JointWorkRatio_PropulsionvsBrakingPhase', 'Mean_WholeLimbWork_PropulsionPhase',...
     'Mean_TotalLimbSupportMoment_Braking_AllNegativeSupportMoment', 'Mean_JointSupportMoment_Braking_AllNegativeSupportMoment', 'Mean_JointContribution_Braking_AllNegativeSupportMoment',...
     'Mean_TotalLimbSupportPower_Braking_AllNegativeSupportPower', 'Mean_JointSupportPower_Braking_AllNegativeSupportPower', 'Mean_JointContribution_Braking_AllNegativeSupportPower',...
     'Mean_TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment', 'Mean_JointSupportMoment_Propulsion_AllNegativeSupportMoment', 'Mean_JointContribution_Propulsion_AllNegativeSupportMoment',...
     'Mean_TotalLimbSupportPower_Propulsion_AllPositiveSupportPower', 'Mean_JointSupportPower_Propulsion_AllPositiveSupportPower', 'Mean_JointContribution_Propulsion_AllPositiveSupportPower',...
     'Mean_JointContribution2LimbWork_PropulsionPhase',...
      'Mean_TotalLimbSupportMoment_Braking_NoFlexorTorque', 'Mean_TotalJointSupportMoment_Braking_NoFlexorTorque', 'Mean_JointSupportMomentContribution_Braking_NoFlexorTorque',...
    'Mean_TotalLimbSupportMoment_Propulsion_NoFlexorTorque', 'Mean_TotalJointSupportMoment_Propulsion_NoFlexorTorque', 'Mean_JointSupportMomentContribution_Propulsion_NoFlexorTorque',...
    'Mean_JointWork_Braking_GenerationNeutralized', 'Mean_WholeLimbWork_Braking_GenerationNeutralized', 'Mean_JointWorkContribution_Braking_GenerationNeutralized',...
    'Mean_JointWork_Propulsion_AbsorptionNeutralized', 'Mean_WholeLimbWork_Propulsion_AbsorptionNeutralized', 'Mean_JointWorkContribution_Propulsion_AbsorptionNeutralized',...
    'Mean_JointAverageAbsorptionMEE', 'Mean_WholeLimbAverageAbsorptionMEE', 'Mean_JointContribution_AverageAbsorptionMEE',...
    'Mean_JointAverageGenerationMEE', 'Mean_WholeLimbAverageGenerationMEE', 'Mean_JointContribution_AverageGenerationMEE',...
    'Mean_JointAveragePower_Braking_GenerationNeutralized', 'Mean_LimbAveragePower_Braking_GenerationNeutralized', 'Mean_JointContribution_AveragePower_GenerationNeutralized',...
    'Mean_JointAveragePower_Propulsion_AbsorptionNeutralized', 'Mean_LimbAveragePower_Propulsion_AbsorptionNeutralized', 'Mean_JointContribution_AveragePower_AbsorptionNeutralized',...
    'Mean_TotalLimbAvgTorqImpulse_Braking_Sagittal_NoFlexTorq', 'Mean_JointAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Propulsion_Sagittal_NoFlexTorq', 'Mean_JointAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Braking_Frontal_NoFlexTorq', 'Mean_JointAverageBrakingTorqueImpulse_Frontal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Propulsion_Frontal_NoFlexTorq', 'Mean_JointAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Braking_Transverse_NoFlexTorq', 'Mean_JointAverageBrakingTorqueImpulse_Transverse_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Propulsion_Transverse_NoFlexTorq', 'Mean_JointAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq',...
     'SD_TotalNegativePower_Joint_EntireContactPhase',...
    'SD_TotalPositivePower_Joint_EntireContactPhase', 'SD_PercentNegativePower_JointContribution_EntireContactPhase', 'SD_PercentPositivePower_JointContribution_EntireContactPhase',...
    'SD_TotalNegativePower_AllJoints_EntireContactPhase', 'SD_TotalPositivePower_AllJoints_EntireContactPhase'...
    ' SD_Total_Joint_Negative_Work_AllPeriodsAcrossContactPhase ', ' SD_Total_Joint_Positive_Work_AllPeriodsAcrossContactPhase ', 'SD_Joint_Work_Ratio_AllPeriodsAcrossContactPhase',...
    'SD_Total_Joint_Work_EntireContactPhase', 'SD_Total_Joint_Torque_Impulse_EntireContactPhase',...
    ' SD_Joint_Percent_MEE_Absorption ', ' SD_Joint_Percent_MEE_Generation ', ' SD_Limb_Absorption_MEE ', ' SD_Limb_Generation_MEE ', 'SD_Joint_Absorption_MEE', 'SD_Joint_Generation_MEE',...
    'SD_Joint_Absorption_TorqueImpulse', 'SD_Joint_Generation_TorqueImpulse', 'SD_Peak_Joint_AngularVelocity_Absorption', 'SD_Peak_Joint_AngularVelocity_Generation', 'SD_HoppingHeight_m',...
    'SD_LimbWorkRatio_BrakingPhase', 'SD_LimbWorkRatio_PropulsionPhase',...
    'SD_JointPercentMEE_ContactPhase', 'SD_WholeLimbMEE_ContactPhase', 'SD_JointMEE_ContactPhase', 'SD_JointTorqueImpulse_ContactPhase',...
    'SD_AnkleandKneeContactMEE', 'SD_AnklePercentMEE_ofAnkleandKneeMEE_Contact', 'SD_KneePercentMEE_ofAnkleandKneeMEE_Contact',...
    'SD_AnkleandKneeBrakingMEE', 'SD_AnklePercentMEE_ofAnkleandKneeMEE_Braking', 'SD_KneePercentMEE_ofAnkleandKneeMEE_Braking',...
    'SD_AnkleandKneePropulsionMEE', 'SD_AnklePercentMEE_ofAnkleandKneeMEE_Propulsion', 'SD_KneePercentMEE_ofAnkleandKneeMEE_Propulsion',...
     'SD_JointFrontalTorqueImpulse_ContactPhase', 'SD_JointTransverseTorqueImpulse_ContactPhase',...
     'SD_Joint_Absorption_FrontalTorqueImpulse', 'SD_Joint_Generation_FrontalTorqueImpulse',...
     'SD_Joint_Absorption_TransverseTorqueImpulse', 'SD_Joint_Generation_TransverseTorqueImpulse',...
     'SD_SagittalRoM_BrakingPhase', 'SD_SagittalRoM_PropulsionPhase',...
     'SD_LengthofFlightPhase_sec', 'SD_LengthofContactPhase_sec', 'SD_LengthofBrakingPhase_sec', 'SD_LengthofPropulsionPhase_sec',...
    'SD_AverageJointAngVel_BrakingPhase', 'SD_AverageJointAngVel_PropulsionPhase',...
    'SD_TimetoPeakJointFlexion_BrakingPhase', 'SD_TimetoPeakJointExtension_PropulsionPhase',...
    'SD_TimetoPeakJointFlexionAngVel_BrakingPhase', 'SD_TimetoPeakJointExtensionAngVel_PropulsionPhase', 'SD_JointAngleAtPeakAngVel_BrakingPhase', 'SD_JointAngleAtPeakAngVel_PropulsionPhase',...
    'SD_PeakJointAngle_BrakingPhase', 'SD_PeakJointAngle_PropulsionPhase',...
    'SD_LengthofHopCycle_sec', 'SD_HopFrequency',...
    'SD_JointInitialContactAngle', 'SD_JointInitialPropulsionPhaseAngle', 'SD_JointAverageBrakingTorque', 'SD_JointAveragePropulsionTorque',...
    'SD_TotalLimbSupportMoment_BrakingPhase','SD_TotalJointSupportMoment_BrakingPhase','SD_JointContribution_SupportMoment_BrakingPhase',...
    'SD_JointContribution_PeakSupportMoment_BrakingPhase','SD_PeakSupportMoment_BrakingPhase','SD_TotalLimbSupportPower_BrakingPhase',...
    'SD_TotalJointSupportPower_BrakingPhase','SD_JointContribution_SupportPower_BrakingPhase','SD_TotalLimbSupportMoment_PropulsionPhase',...
    'SD_TotalJointSupportMoment_PropulsionPhase','SD_JointContribution_SupportMoment_PropulsionPhase','SD_JointContribution_PeakSupportMoment_PropulsionPhase',...
    'SD_PeakSupportMoment_PropulsionPhase','SD_TotalLimbSupportPower_PropulsionPhase','SD_TotalJointSupportPower_PropulsionPhase',...
    'SD_JointContribution_SupportPower_PropulsionPhase',...
    'SD_BetweenLimbTendonThickness_mm','SD_VAS_Rating',...
     'SD_JointWork_BrakingPhase', 'SD_JointContribution2LimbWork_BrakingPhase', 'SD_WholeLimbWork_BrakingPhase',...
     'SD_JointWork_PropulsionPhase', 'SD_JointWorkRatio_PropulsionvsBrakingPhase', 'SD_WholeLimbWork_PropulsionPhase',...
     'SD_TotalLimbSupportMoment_Braking_AllNegativeSupportMoment', 'SD_TotalJointSupportMoment_Braking_AllNegativeSupportMoment', 'SD_JointContribution_BrakingPhase_AllNegativeSupportMoment',...
     'SD_TotalLimbSupportPower_Braking_AllNegativeSupportPower', 'SD_TotalJointSupportPower_Braking_AllNegativeSupportPower', 'SD_JointContribution_BrakingPhase_AllNegativeSupportPower',...
     'SD_TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment', 'SD_TotalJointSupportMoment_Propulsion_AllNegativeSupportMoment', 'SD_JointContribution_PropulsionPhase_AllNegativeSupportMoment',...
     'SD_TotalLimbSupportPower_Propulsion_AllPositiveSupportPower', 'SD_TotalJointSupportPower_Propulsion_AllPositiveSupportPower', 'SD_JointContribution_PropulsionPhase_AllPositiveSupportPower'...
     'SD_JointContribution2LimbWork_PropulsionPhase',...
    'SD_TotalLimbSupportMoment_Braking_NoFlexorTorque', 'SD_TotalJointSupportMoment_Braking_NoFlexorTorque', 'SD_JointSupportMomentContribution_Braking_NoFlexorTorque',...
    'SD_TotalLimbSupportMoment_Propulsion_NoFlexorTorque', 'SD_TotalJointSupportMoment_Propulsion_NoFlexorTorque', 'SD_JointSupportMomentContribution_Propulsion_NoFlexorTorque',...
    'SD_JointWork_Braking_GenerationNeutralized', 'SD_WholeLimbWork_Braking_GenerationNeutralized', 'SD_JointWorkContribution_Braking_GenerationNeutralized',...
    'SD_JointWork_Propulsion_AbsorptionNeutralized', 'SD_WholeLimbWork_Propulsion_AbsorptionNeutralized', 'SD_JointWorkContribution_Propulsion_AbsorptionNeutralized',...
    'SD_JointAverageAbsorptionMEE', 'SD_WholeLimbAverageAbsorptionMEE', 'SD_JointContribution_AverageAbsorptionMEE',...
    'SD_JointAverageGenerationMEE', 'SD_WholeLimbAverageGenerationMEE', 'SD_JointContribution_AverageGenerationMEE',...
    'SD_JointAveragePower_Braking_GenerationNeutralized', 'SD_LimbAveragePower_Braking_GenerationNeutralized', 'SD_JointContribution_AveragePower_GenerationNeutralized',...
    'SD_JointAveragePower_Propulsion_AbsorptionNeutralized', 'SD_LimbAveragePower_Propulsion_AbsorptionNeutralized', 'SD_JointContribution_AveragePower_AbsorptionNeutralized',...
    'SD_TotalLimbAvgTorqImpulse_Braking_Sagittal_NoFlexTorq', 'SD_JointAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Propulsion_Sagittal_NoFlexTorq', 'SD_JointAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Braking_Frontal_NoFlexTorq', 'SD_JointAverageBrakingTorqueImpulse_Frontal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Propulsion_Frontal_NoFlexTorq', 'SD_JointAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Braking_Transverse_NoFlexTorq', 'SD_JointAverageBrakingTorqueImpulse_Transverse_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Propulsion_Transverse_NoFlexTorq', 'SD_JointAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq'};

%Create a table from the JointPower_GroupMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( JointPower_GroupMeansPerHoppingRate, 'VariableNames', VariableNames_PowerEntireCycle ), 'PostQuals_JointPower_GroupMeansPerHoppingRate.xlsx' );

%Create a table from the JointPower_ParticipantMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( JointPower_ParticipantMeansPerHoppingRate, 'VariableNames', VariableNames_PowerEntireCycle ), 'PostQuals_JointPower_ParticipantMeansPerHoppingRate.xlsx' );

    






                                    
VariableNames_JointPower_LimbDiff = { 'Group_ID', 'Participant_ID', 'Joint_ID', 'HoppingRate_ID',...
    'Mean_TotalNegativePower_Joint_Contact',...
    'Mean_TotalPositivePower_Joint_Contact', 'Mean_PercentNegativePower_JointContribution_Contact', 'Mean_PercentPositivePower_JointContribution_Contact',...
    'Mean_TotalNegativePower_AllJoints_Contact', 'Mean_TotalPositivePower_AllJoints_Contact',...
    ' Mean_Total_Joint_Negative_Work ', ' Mean_Total_Joint_Positive_Work ', 'Mean_Joint_Work_Ratio', 'Mean_Total_Joint_Work', 'Mean_Total_Joint_Torque_Impulse', ...
    ' Mean_Joint_Percent_MEE_Absorption ', ' Mean_Joint_Percent_MEE_Generation ', ' Mean_Limb_Absorption_MEE ', ' Mean_Limb_Generation_MEE ', 'Mean_Joint_Absorption_MEE', 'Mean_Joint_Generation_MEE',...
    'Mean_Joint_Absorption_SagittalTorqueImpulse', 'Mean_Joint_Generation_SagittalTorqueImpulse', 'Mean_Peak_Joint_AngularVelocity_Absorption', 'Mean_Peak_Joint_AngularVelocity_Generation',...
    'Mean_HoppingHeight_m', 'Mean_LimbWorkRatio_BrakingPhase', 'Mean_LimbWorkRatio_PropulsionPhase',...
    'Mean_JointPercentMEE_ContactPhase', 'Mean_WholeLimbMEE_ContactPhase', 'Mean_JointMEE_ContactPhase', 'Mean_JointSagittalTorqueImpulse_ContactPhase',...
    'Mean_AnkleandKneeContactMEE', 'Mean_AnklePercentMEE_ofAnkleandKneeMEE_Contact', 'Mean_KneePercentMEE_ofAnkleandKneeMEE_Contact',...
    'Mean_AnkleandKneeBrakingMEE', 'Mean_AnklePercentMEE_ofAnkleandKneeMEE_Braking', 'Mean_KneePercentMEE_ofAnkleandKneeMEE_Braking',...
    'Mean_AnkleandKneePropulsionMEE', 'Mean_AnklePercentMEE_ofAnkleandKneeMEE_Propulsion', 'Mean_KneePercentMEE_ofAnkleandKneeMEE_Propulsion',...
     'Mean_JointFrontalTorqueImpulse_ContactPhase', 'Mean_JointTransverseTorqueImpulse_ContactPhase',...
     'Mean_Joint_Absorption_FrontalTorqueImpulse', 'Mean_Joint_Generation_FrontalTorqueImpulse',...
     'Mean_Joint_Absorption_TransverseTorqueImpulse', 'Mean_Joint_Generation_TransverseTorqueImpulse',...
     'Mean_SagittalRoM_BrakingPhase', 'Mean_SagittalRoM_PropulsionPhase'...,
     'Mean_LengthofFlightPhase_sec', 'Mean_LengthofContactPhase_sec', 'Mean_LengthofBrakingPhase_sec', 'Mean_LengthofPropulsionPhase_sec',...
    'Mean_AverageJointAngVel_BrakingPhase', 'Mean_AverageJointAngVel_PropulsionPhase',...
    'Mean_TimetoPeakJointFlexion_BrakingPhase', 'Mean_TimetoPeakJointExtension_PropulsionPhase',...
    'Mean_TimetoPeakJointFlexionAngVel_BrakingPhase', 'Mean_TimetoPeakJointExtensionAngVel_PropulsionPhase', 'Mean_JointAngleAtPeakAngVel_BrakingPhase', 'Mean_JointAngleAtPeakAngVel_PropulsionPhase',...
    'Mean_PeakJointAngle_BrakingPhase', 'Mean_PeakJointAngle_PropulsionPhase',...
    'Mean_LengthofHopCycle_sec', 'Mean_HopFrequency',...
    'Mean_JointInitialContactAngle', 'Mean_JointInitialPropulsionPhaseAngle', 'Mean_JointAverageBrakingTorque', 'Mean_JointAveragePropulsionTorque',...
    'Mean_TotalLimbSupportMoment_BrakingPhase','Mean_TotalJointSupportMoment_BrakingPhase','Mean_JointContribution_SupportMoment_BrakingPhase',...
    'Mean_JointContribution_PeakSupportMoment_BrakingPhase','Mean_PeakSupportMoment_BrakingPhase','Mean_TotalLimbSupportPower_BrakingPhase',...
    'Mean_TotalJointSupportPower_BrakingPhase','Mean_JointContribution_SupportPower_BrakingPhase','Mean_TotalLimbSupportMoment_PropulsionPhase',...
    'Mean_TotalJointSupportMoment_PropulsionPhase','Mean_JointContribution_SupportMoment_PropulsionPhase','Mean_JointContribution_PeakSupportMoment_PropulsionPhase',...
    'Mean_PeakSupportMoment_PropulsionPhase','Mean_TotalLimbSupportPower_PropulsionPhase','Mean_TotalJointSupportPower_PropulsionPhase',...
    'Mean_JointContribution_SupportPower_PropulsionPhase',...
    'Mean_BetweenLimbTendonThickness_mm','Mean_BetweenLimb_VAS_Rating',...
     'Mean_JointWork_BrakingPhase', 'Mean_JointContribution2LimbWork_BrakingPhase', 'Mean_WholeLimbWork_BrakingPhase',...
     'Mean_JointWork_PropulsionPhase', 'Mean_JointWorkRatio_PropulsionvsBrakingPhase', 'Mean_WholeLimbWork_PropulsionPhase',...
     'Mean_TotalLimbSupportMoment_Braking_AllNegativeSupportMoment', 'Mean_JointSupportMoment_Braking_AllNegativeSupportMoment', 'Mean_JointContribution_Braking_AllNegativeSupportMoment',...
     'Mean_TotalLimbSupportPower_Braking_AllNegativeSupportPower', 'Mean_JointSupportPower_Braking_AllNegativeSupportPower', 'Mean_JointContribution_Braking_AllNegativeSupportPower',...
     'Mean_TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment', 'Mean_JointSupportMoment_Propulsion_AllNegativeSupportMoment', 'Mean_JointContribution_Propulsion_AllNegativeSupportMoment',...
     'Mean_TotalLimbSupportPower_Propulsion_AllPositiveSupportPower', 'Mean_JointSupportPower_Propulsion_AllPositiveSupportPower', 'Mean_JointContribution_Propulsion_AllPositiveSupportPower',...
     'Mean_JointContribution2LimbWork_PropulsionPhase',...
     'Mean_TotalLimbSupportMoment_Braking_NoFlexorTorque', 'Mean_TotalJointSupportMoment_Braking_NoFlexorTorque', 'Mean_JointSupportMomentContribution_Braking_NoFlexorTorque',...
    'Mean_TotalLimbSupportMoment_Propulsion_NoFlexorTorque', 'Mean_TotalJointSupportMoment_Propulsion_NoFlexorTorque', 'Mean_JointSupportMomentContribution_Propulsion_NoFlexorTorque',...
    'Mean_JointWork_Braking_GenerationNeutralized', 'Mean_WholeLimbWork_Braking_GenerationNeutralized', 'Mean_JointWorkContribution_Braking_GenerationNeutralized',...
    'Mean_JointWork_Propulsion_AbsorptionNeutralized', 'Mean_WholeLimbWork_Propulsion_AbsorptionNeutralized', 'Mean_JointWorkContribution_Propulsion_AbsorptionNeutralized',...
    'Mean_JointAverageAbsorptionMEE', 'Mean_WholeLimbAverageAbsorptionMEE', 'Mean_JointContribution_AverageAbsorptionMEE',...
    'Mean_JointAverageGenerationMEE', 'Mean_WholeLimbAverageGenerationMEE', 'Mean_JointContribution_AverageGenerationMEE',...
    'Mean_JointAveragePower_Braking_GenerationNeutralized', 'Mean_LimbAveragePower_Braking_GenerationNeutralized', 'Mean_JointContribution_AveragePower_GenerationNeutralized',...
    'Mean_JointAveragePower_Propulsion_AbsorptionNeutralized', 'Mean_LimbAveragePower_Propulsion_AbsorptionNeutralized', 'Mean_JointContribution_AveragePower_AbsorptionNeutralized',...
    'Mean_TotalLimbAvgTorqImpulse_Braking_Sagittal_NoFlexTorq', 'Mean_JointAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Propulsion_Sagittal_NoFlexTorq', 'Mean_JointAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Braking_Frontal_NoFlexTorq', 'Mean_JointAverageBrakingTorqueImpulse_Frontal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Propulsion_Frontal_NoFlexTorq', 'Mean_JointAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Braking_Transverse_NoFlexTorq', 'Mean_JointAverageBrakingTorqueImpulse_Transverse_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq',...
    'Mean_TotalLimbAvgTorqImpulse_Propulsion_Transverse_NoFlexTorq', 'Mean_JointAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq', 'Mean_JntContrbutn_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq',...
     'SD_TotalNegativePower_Joint_Contact',...
    'SD_TotalPositivePower_Joint_Contact', 'SD_PercentNegativePower_JointContribution_Contact', 'SD_PercentPositivePower_JointContribution_Contact',...
    'SD_TotalNegativePower_AllJoints_Contact', 'SD_TotalPositivePower_AllJoints_Contact'...
    ' SD_Total_Joint_Negative_Work ', ' SD_Total_Joint_Positive_Work ', 'SD_Joint_Work_Ratio', 'SD_Total_Joint_Work', 'SD_Total_Joint_Torque_Impulse',...
    ' SD_Joint_Percent_MEE_Absorption ', ' SD_Joint_Percent_MEE_Generation ', ' SD_Limb_Absorption_MEE ', ' SD_Limb_Generation_MEE ', 'SD_Joint_Absorption_MEE', 'SD_Joint_Generation_MEE',...
    'SD_Joint_Absorption_TorqueImpulse', 'SD_Joint_Generation_TorqueImpulse', 'SD_Peak_Joint_AngularVelocity_Absorption', 'SD_Peak_Joint_AngularVelocity_Generation', 'SD_HoppingHeight_m',...
    'SD_LimbWorkRatio_BrakingPhase', 'SD_LimbWorkRatio_PropulsionPhase',...
    'SD_JointPercentMEE_ContactPhase', 'SD_WholeLimbMEE_ContactPhase', 'SD_JointMEE_ContactPhase', 'SD_JointTorqueImpulse_ContactPhase',...
    'SD_AnkleandKneeContactMEE', 'SD_AnklePercentMEE_ofAnkleandKneeMEE_Contact', 'SD_KneePercentMEE_ofAnkleandKneeMEE_Contact',...
    'SD_AnkleandKneeBrakingMEE', 'SD_AnklePercentMEE_ofAnkleandKneeMEE_Braking', 'SD_KneePercentMEE_ofAnkleandKneeMEE_Braking',...
    'SD_AnkleandKneePropulsionMEE', 'SD_AnklePercentMEE_ofAnkleandKneeMEE_Propulsion', 'SD_KneePercentMEE_ofAnkleandKneeMEE_Propulsion',...
     'SD_JointFrontalTorqueImpulse_ContactPhase', 'SD_JointTransverseTorqueImpulse_ContactPhase',...
     'SD_Joint_Absorption_FrontalTorqueImpulse', 'SD_Joint_Generation_FrontalTorqueImpulse',...
     'SD_Joint_Absorption_TransverseTorqueImpulse', 'SD_Joint_Generation_TransverseTorqueImpulse',...
     'SD_SagittalRoM_BrakingPhase', 'SD_SagittalRoM_PropulsionPhase',...
     'SD_LengthofFlightPhase_sec', 'SD_LengthofContactPhase_sec', 'SD_LengthofBrakingPhase_sec', 'SD_LengthofPropulsionPhase_sec',...
    'SD_AverageJointAngVel_BrakingPhase', 'SD_AverageJointAngVel_PropulsionPhase',...
    'SD_TimetoPeakJointFlexion_BrakingPhase', 'SD_TimetoPeakJointExtension_PropulsionPhase',...
    'SD_TimetoPeakJointFlexionAngVel_BrakingPhase', 'SD_TimetoPeakJointExtensionAngVel_PropulsionPhase', 'SD_JointAngleAtPeakAngVel_BrakingPhase', 'SD_JointAngleAtPeakAngVel_PropulsionPhase',...
    'SD_PeakJointAngle_BrakingPhase', 'SD_PeakJointAngle_PropulsionPhase',...
    'SD_LengthofHopCycle_sec', 'SD_HopFrequency',...
    'SD_JointInitialContactAngle', 'SD_JointInitialPropulsionPhaseAngle', 'SD_JointAverageBrakingTorque', 'SD_JointAveragePropulsionTorque',...
    'SD_TotalLimbSupportMoment_BrakingPhase','SD_TotalJointSupportMoment_BrakingPhase','SD_JointContribution_SupportMoment_BrakingPhase',...
    'SD_JointContribution_PeakSupportMoment_BrakingPhase','SD_PeakSupportMoment_BrakingPhase','SD_TotalLimbSupportPower_BrakingPhase',...
    'SD_TotalJointSupportPower_BrakingPhase','SD_JointContribution_SupportPower_BrakingPhase','SD_TotalLimbSupportMoment_PropulsionPhase',...
    'SD_TotalJointSupportMoment_PropulsionPhase','SD_JointContribution_SupportMoment_PropulsionPhase','SD_JointContribution_PeakSupportMoment_PropulsionPhase',...
    'SD_PeakSupportMoment_PropulsionPhase','SD_TotalLimbSupportPower_PropulsionPhase','SD_TotalJointSupportPower_PropulsionPhase',...
    'SD_JointContribution_SupportPower_PropulsionPhase',...
    'SD_BetweenLimbTendonThickness_mm','SD_BetweenLimb_VAS_Rating',...
     'SD_JointWork_BrakingPhase', 'SD_JointContribution2LimbWork_BrakingPhase', 'SD_WholeLimbWork_BrakingPhase',...
     'SD_JointWork_PropulsionPhase', 'SD_JointWorkRatio_PropulsionvsBrakingPhase', 'SD_WholeLimbWork_PropulsionPhase',...
     'SD_TotalLimbSupportMoment_Braking_AllNegativeSupportMoment', 'SD_JointSupportMoment_Braking_AllNegativeSupportMoment', 'SD_JointContribution_Braking_AllNegativeSupportMoment',...
     'SD_TotalLimbSupportPower_Braking_AllNegativeSupportPower', 'SD_JointSupportPower_Braking_AllNegativeSupportPower', 'SD_JointContribution_Braking_AllNegativeSupportPower',...
     'SD_TotalLimbSupportMoment_Propulsion_AllNegativeSupportMoment', 'SD_JointSupportMoment_Propulsion_AllNegativeSupportMoment', 'SD_JointContribution_Propulsion_AllNegativeSupportMoment',...
     'SD_TotalLimbSupportPower_Propulsion_AllPositiveSupportPower', 'SD_JointSupportPower_Propulsion_AllPositiveSupportPower', 'SD_JointContribution_Propulsion_AllPositiveSupportPower',...
     'SD_JointContribution2LimbWork_PropulsionPhase',...
     ' SD_TotalLimbSupportMoment_Braking_NoFlexorTorque', ' SD_TotalJointSupportMoment_Braking_NoFlexorTorque', ' SD_JointSupportMomentContribution_Braking_NoFlexorTorque',...
    ' SD_TotalLimbSupportMoment_Propulsion_NoFlexorTorque', ' SD_TotalJointSupportMoment_Propulsion_NoFlexorTorque', ' SD_JointSupportMomentContribution_Propulsion_NoFlexorTorque',...
    ' SD_JointWork_Braking_GenerationNeutralized', ' SD_WholeLimbWork_Braking_GenerationNeutralized', ' SD_JointWorkContribution_Braking_GenerationNeutralized',...
    ' SD_JointWork_Propulsion_AbsorptionNeutralized', ' SD_WholeLimbWork_Propulsion_AbsorptionNeutralized', ' SD_JointWorkContribution_Propulsion_AbsorptionNeutralized',...
    'SD_JointAverageAbsorptionMEE', 'SD_WholeLimbAverageAbsorptionMEE', 'SD_JointContribution_AverageAbsorptionMEE',...
    'SD_JointAverageGenerationMEE', 'SD_WholeLimbAverageGenerationMEE', 'SD_JointContribution_AverageGenerationMEE',...
    'SD_JointAveragePower_Braking_GenerationNeutralized', 'SD_LimbAveragePower_Braking_GenerationNeutralized', 'SD_JointContribution_AveragePower_GenerationNeutralized',...
    'SD_JointAveragePower_Propulsion_AbsorptionNeutralized', 'SD_LimbAveragePower_Propulsion_AbsorptionNeutralized', 'SD_JointContribution_AveragePower_AbsorptionNeutralized',...
    'SD_TotalLimbAvgTorqImpulse_Braking_Sagittal_NoFlexTorq', 'SD_JointAverageBrakingTorqueImpulse_Sagittal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Propulsion_Sagittal_NoFlexTorq', 'SD_JointAveragePropulsionTorqueImpulse_Sagittal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Braking_Frontal_NoFlexTorq', 'SD_JointAverageBrakingTorqueImpulse_Frontal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Front_Brakng_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Propulsion_Frontal_NoFlexTorq', 'SD_JointAveragePropulsionTorqueImpulse_Frontal_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Front_Propulsn_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Braking_Transverse_NoFlexTorq', 'SD_JointAverageBrakingTorqueImpulse_Transverse_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Trans_Brakng_NoFlexTorq',...
    'SD_TotalLimbAvgTorqImpulse_Propulsion_Transverse_NoFlexTorq', 'SD_JointAveragePropulsionTorqueImpulse_Transverse_NoFlexTorq', 'SD_JntContrbutn_LimbAvrgTorqImpuls_Trans_Propulsn_NoFlexTorq',...
     'Mean_Ratio_TotalNegativePower_Joint_Contact',...
    'Mean_Ratio_TotalPositivePower_Joint_Contact', 'Mean_Ratio_PercentNegativePower_JointContribution_Contact', 'Mean_Ratio_PercentPositivePower_JointContribution_Contact',...
    'Mean_Ratio_TotalNegativePower_AllJoints_Contact', 'Mean_Ratio_TotalPositivePower_AllJoints_Contact',...
    ' Mean_Ratio_Total_Joint_Negative_Work ', ' Mean_Ratio_Total_Joint_Positive_Work ', 'Mean_Ratio_Joint_Work_Ratio', 'Mean_Ratio_Total_Joint_Work', 'Mean_Ratio_Total_Joint_Torque_Impulse', ...
    ' Mean_Ratio_Joint_Percent_MEE_Absorption ', ' Mean_Ratio_Joint_Percent_MEE_Generation ', ' Mean_Ratio_Limb_Absorption_MEE ', ' Mean_Ratio_Limb_Generation_MEE ', 'Mean_Ratio_Joint_Absorption_MEE', 'Mean_Ratio_Joint_Generation_MEE',...
    'Mean_Ratio_Joint_Absorption_SagittalTorqueImpulse', 'Mean_Ratio_Joint_Generation_SagittalTorqueImpulse', 'Mean_Ratio_Peak_Joint_AngularVelocity_Absorption', 'Mean_Ratio_Peak_Joint_AngularVelocity_Generation',...
    'Mean_Ratio_HoppingHeight_m', 'Mean_Ratio_LimbWorkRatio_BrakingPhase', 'Mean_Ratio_LimbWorkRatio_PropulsionPhase',...
    'Mean_Ratio_JointPercentMEE_ContactPhase', 'Mean_Ratio_WholeLimbMEE_ContactPhase', 'Mean_Ratio_JointMEE_ContactPhase', 'Mean_Ratio_JointSagittalTorqueImpulse_ContactPhase',...
    'Mean_Ratio_AnkleandKneeContactMEE', 'Mean_Ratio_AnklePercentMEE_ofAnkleandKneeMEE_Contact', 'Mean_Ratio_KneePercentMEE_ofAnkleandKneeMEE_Contact',...
    'Mean_Ratio_AnkleandKneeBrakingMEE', 'Mean_Ratio_AnklePercentMEE_ofAnkleandKneeMEE_Braking', 'Mean_Ratio_KneePercentMEE_ofAnkleandKneeMEE_Braking',...
    'Mean_Ratio_AnkleandKneePropulsionMEE', 'Mean_Ratio_AnklePercentMEE_ofAnkleandKneeMEE_Propulsion', 'Mean_Ratio_KneePercentMEE_ofAnkleandKneeMEE_Propulsion',...
     'Mean_Ratio_JointFrontalTorqueImpulse_ContactPhase', 'Mean_Ratio_JointTransverseTorqueImpulse_ContactPhase',...
     'Mean_Ratio_Joint_Absorption_FrontalTorqueImpulse', 'Mean_Ratio_Joint_Generation_FrontalTorqueImpulse',...
     'Mean_Ratio_Joint_Absorption_TransverseTorqueImpulse', 'Mean_Ratio_Joint_Generation_TransverseTorqueImpulse',...
     'Mean_Ratio_SagittalRoM_BrakingPhase', 'Mean_Ratio_SagittalRoM_PropulsionPhase'...,
     'Mean_Ratio_LengthofFlightPhase_sec', 'Mean_Ratio_LengthofContactPhase_sec', 'Mean_Ratio_LengthofBrakingPhase_sec', 'Mean_Ratio_LengthofPropulsionPhase_sec',...
    'Mean_Ratio_AverageJointAngVel_BrakingPhase', 'Mean_Ratio_AverageJointAngVel_PropulsionPhase',...
    'Mean_Ratio_TimetoPeakJointFlexion_BrakingPhase', 'Mean_Ratio_TimetoPeakJointExtension_PropulsionPhase',...
    'Mean_Ratio_TimetoPeakJointFlexionAngVel_BrakingPhase', 'Mean_Ratio_TimetoPeakJointExtensionAngVel_PropulsionPhase', 'Mean_Ratio_JointAngleAtPeakAngVel_BrakingPhase', 'Mean_Ratio_JointAngleAtPeakAngVel_PropulsionPhase',...
    'Mean_Ratio_PeakJointAngle_BrakingPhase', 'Mean_Ratio_PeakJointAngle_PropulsionPhase',...
    'Mean_Ratio_LengthofHopCycle_sec', 'Mean_Ratio_HopFrequency',...
    'Mean_Ratio_JointInitialContactAngle', 'Mean_Ratio_JointInitialPropulsionPhaseAngle', 'Mean_Ratio_JointAverageBrakingTorque', 'Mean_Ratio_JointAveragePropulsionTorque',...
    'Mean_Ratio_TotalLimbSupportMoment_BrakingPhase','Mean_Ratio_TotalJointSupportMoment_BrakingPhase','Mean_Ratio_JointContribution_SupportMoment_BrakingPhase',...
    'Mean_Ratio_JointContribution_PeakSupportMoment_BrakingPhase','Mean_Ratio_PeakSupportMoment_BrakingPhase','Mean_Ratio_TotalLimbSupportPower_BrakingPhase',...
    'Mean_Ratio_TotalJointSupportPower_BrakingPhase','Mean_Ratio_JointContribution_SupportPower_BrakingPhase','Mean_Ratio_TotalLimbSupportMoment_PropulsionPhase',...
    'Mean_Ratio_TotalJointSupportMoment_PropulsionPhase','Mean_Ratio_JointContribution_SupportMoment_PropulsionPhase','Mean_Ratio_JointContribution_PeakSupportMoment_PropulsionPhase',...
    'Mean_Ratio_PeakSupportMoment_PropulsionPhase','Mean_Ratio_TotalLimbSupportPower_PropulsionPhase','Mean_Ratio_TotalJointSupportPower_PropulsionPhase',...
    'Mean_Ratio_JointContribution_SupportPower_PropulsionPhase',...
    'Mean_Ratio_TendonThickness_mm','Mean_Ratio_VAS_Rating',...
     'Mean_Ratio_JointWork_BrakingPhase', 'Mean_Ratio_JointContribution2LimbWork_BrakingPhase', 'Mean_Ratio_WholeLimbWork_BrakingPhase',...
     'Mean_Ratio_JointWork_PropulsionPhase', 'Mean_Ratio_JointWorkRatio_PropulsionvsBrakingPhase', 'Mean_Ratio_WholeLimbWork_PropulsionPhase',...
     'Mean_Ratio_TotalLimbSupportMoment_Braking_AllSupportMoment', 'Mean_Ratio_JointSupportMoment_Braking_AllSupportMoment', 'Mean_Ratio_JointContribution_Braking_AllSupportMoment',...
     'Mean_Ratio_TotalLimbSupportPower_Braking_AllSupportPower', 'Mean_Ratio_JointSupportPower_Braking_AllSupportPower', 'Mean_Ratio_JointContribution_Braking_AllSupportPower',...
     'Mean_Ratio_TotalLimbSupportMoment_Propulsion_AllSupportMoment', 'Mean_Ratio_JointSupportMoment_Propulsion_AllSupportMoment', 'Mean_Ratio_JointContribution_Propulsion_AllSupportMoment',...
     'Mean_Ratio_TotalLimbSupportPower_Propulsion_AllSupportPower', 'Mean_Ratio_JointSupportPower_Propulsion_AllSupportPower', 'Mean_Ratio_JointContribution_Propulsion_AllSupportPower',...
     'Mean_Ratio_JointContribution2LimbWork_PropulsionPhase',...
     'Mean_Ratio_TotalLimbSupportMoment_Braking_NoFlexorTorque', 'Mean_Ratio_TotalJointSupportMoment_Braking_NoFlexorTorque', 'Mean_Ratio_JointMomentContribution_Braking_NoFlexorTorque',...
    'Mean_Ratio_TotalLimbSupportMoment_Propulsion_NoFlexorTorque', 'Mean_Ratio_TotalJointSupportMoment_Propulsion_NoFlexorTorque', 'Mean_Ratio_JointMomentContribution_Propulsion_NoFlexorTorque',...
    'Mean_Ratio_JointWork_Braking_GenerationNeutralized', 'Mean_Ratio_WholeLimbWork_Braking_GenerationNeutralized', 'Mean_Ratio_JointWorkContribution_Braking_GenerationNeutralized',...
    'Mean_Ratio_JointWork_Propulsion_AbsorptionNeutralized', 'Mean_Ratio_WholeLimbWork_Propulsion_AbsorptionNeutralized', 'Mean_Ratio_JointWrkCntributn_Propulsion_AbsorptionNeutralized',...
    'Mean_Ratio_JointAverageAbsorptionMEE', 'Mean_Ratio_WholeLimbAverageAbsorptionMEE', 'Mean_Ratio_JointContribution_AverageAbsorptionMEE',...
    'Mean_Ratio_JointAverageGenerationMEE', 'Mean_Ratio_WholeLimbAverageGenerationMEE', 'Mean_Ratio_JointContribution_AverageGenerationMEE',...
    'Mean_Ratio_JointAveragePower_Braking_GenerationNeutralized', 'Mean_Ratio_LimbAveragePower_Braking_GenerationNeutralized', 'Mean_Ratio_JointContribution_AveragePower_GenerationNeutralized',...
    'Mean_Ratio_JointAveragePower_Propulsion_AbsorptionNeutralized', 'Mean_Ratio_LimbAveragePower_Propulsion_AbsorptionNeutralized', 'Mean_Ratio_JointContribution_AveragePower_AbsorptionNeutralized',...
    'Mean_Ratio_TotalLimbAvgTorqImpulse_Brkng_Sagittal_NoFlexTorq', 'Mean_Ratio_JointAverageBrkngTorqueImpulse_Sagitt_NoFlexTorq', 'Mean_Ratio_JntContrbutn_AvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq',...
    'Mean_Ratio_TotalLimbAvgTorqImpulse_Propulsn_Sagittal_NoFlexTorq', 'Mean_Ratio_JointAveragePropulsnTorqueImpulse_Sagitt_NoFlexTorq', 'Mean_Ratio_JntContrbutn_AvrgTorqImpuls_Sagit_Propulsn_NoFlxTorq',...
    'Mean_Ratio_TotalLimbAvgTorqImpulse_Brkng_Frontal_NoFlexTorq', 'Mean_Ratio_JointAverageBrkngTorqueImpulse_Frontal_NoFlexTorq', 'Mean_Ratio_JntContrbutn_AvrgTorqImpuls_Front_Brakng_NoFlxTorq',...
    'Mean_Ratio_TotalLimbAvgTorqImpulse_Propulsn_Frontal_NoFlexTorq', 'Mean_Ratio_JointAveragePropulsnTorqueImpulse_Frontal_NoFlexTorq', 'Mean_Ratio_JntContrbutn_AvrgTorqImpuls_Front_Propulsn_NoFlxTorq',...
    'Mean_Ratio_TotalLimbAvgTorqImpulse_Brkng_Transverse_NoFlexTorq', 'Mean_Ratio_JointAverageBrkngTorqueImpulse_Transverse_NoFlexTorq', 'Mean_Ratio_JntContrbutn_AvrgTorqImpuls_Trans_Brakng_NoFlexTorq',...
    'Mean_Ratio_TotalLimbAvgTorqImpulse_Propulsn_Trans_NoFlexTorq', 'Mean_Ratio_JointAveragePropulsnTorqueImpulse_Trans_NoFlexTorq', 'Mean_Ratio_JntContrbutn_AvrgTorqImpuls_Trans_Propulsn_NoFlxTorq',...
     'SD_Ratio_TotalNegativePower_Joint_Contact',...
    'SD_Ratio_TotalPositivePower_Joint_Contact', 'SD_Ratio_PercentNegativePower_JointContribution_Contact', 'SD_Ratio_PercentPositivePower_JointContribution_Contact',...
    'SD_Ratio_TotalNegativePower_AllJoints_Contact', 'SD_Ratio_TotalPositivePower_AllJoints_Contact'...
    ' SD_Ratio_Total_Joint_Negative_Work ', ' SD_Ratio_Total_Joint_Positive_Work ', 'SD_Ratio_Joint_Work_Ratio', 'SD_Ratio_Total_Joint_Work', 'SD_Ratio_Total_Joint_Torque_Impulse',...
    ' SD_Ratio_Joint_Percent_MEE_Absorption ', ' SD_Ratio_Joint_Percent_MEE_Generation ', ' SD_Ratio_Limb_Absorption_MEE ', ' SD_Ratio_Limb_Generation_MEE ', 'SD_Ratio_Joint_Absorption_MEE', 'SD_Ratio_Joint_Generation_MEE',...
    'SD_Ratio_Joint_Absorption_TorqueImpulse', 'SD_Ratio_Joint_Generation_TorqueImpulse', 'SD_Ratio_Peak_Joint_AngularVelocity_Absorption', 'SD_Ratio_Peak_Joint_AngularVelocity_Generation', 'SD_Ratio_HoppingHeight_m',...
    'SD_Ratio_LimbWorkRatio_BrakingPhase', 'SD_Ratio_LimbWorkRatio_PropulsionPhase',...
    'SD_Ratio_JointPercentMEE_ContactPhase', 'SD_Ratio_WholeLimbMEE_ContactPhase', 'SD_Ratio_JointMEE_ContactPhase', 'SD_Ratio_JointTorqueImpulse_ContactPhase',...
    'SD_Ratio_AnkleandKneeContactMEE', 'SD_Ratio_AnklePercentMEE_ofAnkleandKneeMEE_Contact', 'SD_Ratio_KneePercentMEE_ofAnkleandKneeMEE_Contact',...
    'SD_Ratio_AnkleandKneeBrakingMEE', 'SD_Ratio_AnklePercentMEE_ofAnkleandKneeMEE_Braking', 'SD_Ratio_KneePercentMEE_ofAnkleandKneeMEE_Braking',...
    'SD_Ratio_AnkleandKneePropulsionMEE', 'SD_Ratio_AnklePercentMEE_ofAnkleandKneeMEE_Propulsion', 'SD_Ratio_KneePercentMEE_ofAnkleandKneeMEE_Propulsion',...
     'SD_Ratio_JointFrontalTorqueImpulse_ContactPhase', 'SD_Ratio_JointTransverseTorqueImpulse_ContactPhase',...
     'SD_Ratio_Joint_Absorption_FrontalTorqueImpulse', 'SD_Ratio_Joint_Generation_FrontalTorqueImpulse',...
     'SD_Ratio_Joint_Absorption_TransverseTorqueImpulse', 'SD_Ratio_Joint_Generation_TransverseTorqueImpulse',...
     'SD_Ratio_SagittalRoM_BrakingPhase', 'SD_Ratio_SagittalRoM_PropulsionPhase',...
     'SD_Ratio_LengthofFlightPhase_sec', 'SD_Ratio_LengthofContactPhase_sec', 'SD_Ratio_LengthofBrakingPhase_sec', 'SD_Ratio_LengthofPropulsionPhase_sec',...
    'SD_Ratio_AverageJointAngVel_BrakingPhase', 'SD_Ratio_AverageJointAngVel_PropulsionPhase',...
    'SD_Ratio_TimetoPeakJointFlexion_BrakingPhase', 'SD_Ratio_TimetoPeakJointExtension_PropulsionPhase',...
    'SD_Ratio_TimetoPeakJointFlexionAngVel_BrakingPhase', 'SD_Ratio_TimetoPeakJointExtensionAngVel_PropulsionPhase', 'SD_Ratio_JointAngleAtPeakAngVel_BrakingPhase', 'SD_Ratio_JointAngleAtPeakAngVel_PropulsionPhase',...
    'SD_Ratio_PeakJointAngle_BrakingPhase', 'SD_Ratio_PeakJointAngle_PropulsionPhase',...
    'SD_Ratio_LengthofHopCycle_sec', 'SD_Ratio_HopFrequency',...
    'SD_Ratio_JointInitialContactAngle', 'SD_Ratio_JointInitialPropulsionPhaseAngle', 'SD_Ratio_JointAverageBrakingTorque', 'SD_Ratio_JointAveragePropulsionTorque',...
    'SD_Ratio_TotalLimbSupportMoment_BrakingPhase','SD_Ratio_TotalJointSupportMoment_BrakingPhase','SD_Ratio_JointContribution_SupportMoment_BrakingPhase',...
    'SD_Ratio_JointContribution_PeakSupportMoment_BrakingPhase','SD_Ratio_PeakSupportMoment_BrakingPhase','SD_Ratio_TotalLimbSupportPower_BrakingPhase',...
    'SD_Ratio_TotalJointSupportPower_BrakingPhase','SD_Ratio_JointContribution_SupportPower_BrakingPhase','SD_Ratio_TotalLimbSupportMoment_PropulsionPhase',...
    'SD_Ratio_TotalJointSupportMoment_PropulsionPhase','SD_Ratio_JointContribution_SupportMoment_PropulsionPhase','SD_Ratio_JointContribution_PeakSupportMoment_PropulsionPhase',...
    'SD_Ratio_PeakSupportMoment_PropulsionPhase','SD_Ratio_TotalLimbSupportPower_PropulsionPhase','SD_Ratio_TotalJointSupportPower_PropulsionPhase',...
    'SD_Ratio_JointContribution_SupportPower_PropulsionPhase',...
    'SD_Ratio_BetweenLimbTendonThickness_mm','SD_Ratio_BetweenLimb_VAS_Rating',...
     'SD_Ratio_JointWork_BrakingPhase', 'SD_Ratio_JointContribution2LimbWork_BrakingPhase', 'SD_Ratio_WholeLimbWork_BrakingPhase',...
     'SD_Ratio_JointWork_PropulsionPhase', 'SD_Ratio_JointWorkRatio_PropulsionvsBrakingPhase', 'SD_Ratio_WholeLimbWork_PropulsionPhase',...
     'SD_Ratio_TotalLimbSupportMoment_Braking_AllSupportMoment', 'SD_Ratio_JointSupportMoment_Braking_AllSupportMoment', 'SD_Ratio_JointContribution_Braking_AllSupportMoment',...
     'SD_Ratio_TotalLimbSupportPower_Braking_AllSupportPower', 'SD_Ratio_JointSupportPower_Braking_AllSupportPower', 'SD_Ratio_JointContribution_Braking_AllSupportPower',...
     'SD_Ratio_TotalLimbSupportMoment_Propulsion_AllSupportMoment', 'SD_Ratio_JointSupportMoment_Propulsion_AllSupportMoment', 'SD_Ratio_JointContribution_Propulsion_AllSupportMoment',...
     'SD_Ratio_TotalLimbSupportPower_Propulsion_AllSupportPower', 'SD_Ratio_JointSupportPower_Propulsion_AllSupportPower', 'SD_Ratio_JointContribution_Propulsion_AllSupportPower',...
     'SD_Ratio_JointContribution2LimbWork_PropulsionPhase',...
     ' SD_Ratio_TotalLimbSupportMoment_Braking_NoFlexorTorque', ' SD_Ratio_TotalJointSupportMoment_Braking_NoFlexorTorque', ' SD_Ratio_JointSupportMomentContribution_Braking_NoFlexorTorque',...
    ' SD_Ratio_TotalLimbSupportMoment_Propulsion_NoFlexorTorque', ' SD_Ratio_TotalJointSupportMoment_Propulsion_NoFlexorTorque', ' SD_Ratio_JointMomentContribution_Propulsion_NoFlexorTorque',...
    ' SD_Ratio_JointWork_Braking_GenerationNeutralized', ' SD_Ratio_WholeLimbWork_Braking_GenerationNeutralized', ' SD_Ratio_JointWorkContribution_Braking_GenerationNeutralized',...
    ' SD_Ratio_JointWork_Propulsion_AbsorptionNeutralized', ' SD_Ratio_WholeLimbWork_Propulsion_AbsorptionNeutralized', ' SD_Ratio_JointWrkContributn_Propulsion_AbsorptionNeutralized',...
    'SD_Ratio_JointAverageAbsorptionMEE', 'SD_Ratio_WholeLimbAverageAbsorptionMEE', 'SD_Ratio_JointContribution_AverageAbsorptionMEE',...
    'SD_Ratio_JointAverageGenerationMEE', 'SD_Ratio_WholeLimbAverageGenerationMEE', 'SD_Ratio_JointContribution_AverageGenerationMEE',...
    'SD_Ratio_JointAveragePower_Braking_GenerationNeutralized', 'SD_Ratio_LimbAveragePower_Braking_GenerationNeutralized', 'SD_Ratio_JointContribution_AveragePower_GenerationNeutralized',...
    'SD_Ratio_JointAveragePower_Propulsion_AbsorptionNeutralized', 'SD_Ratio_LimbAveragePower_Propulsion_AbsorptionNeutralized', 'SD_Ratio_JointContribution_AveragePower_AbsorptionNeutralized',...
    'SD_Ratio_TotalLimbAvgTorqImpulse_Brkng_Sagittal_NoFlexTorq', 'SD_Ratio_JointAverageBrkngTorqueImpulse_Sagittal_NoFlexTorq', 'SD_Ratio_JntContrbutn_AvrgTorqImpuls_Sagitt_Brakng_NoFlexTorq',...
    'SD_Ratio_TotalLimbAvgTorqImpulse_Propulsn_Sagittal_NoFlexTorq', 'SD_Ratio_JointAveragePropulsnTorqueImpulse_Sagittal_NoFlexTorq', 'SD_Ratio_JntContrbutn_AvrgTorqImpuls_Sagitt_Propulsn_NoFlexTorq',...
    'SD_Ratio_TotalLimbAvgTorqImpulse_Brkng_Frontal_NoFlexTorq', 'SD_Ratio_JointAverageBrkngTorqueImpulse_Frontal_NoFlexTorq', 'SD_Ratio_JntContrbutn_AvrgTorqImpuls_Front_Brakng_NoFlexTorq',...
    'SD_Ratio_TotalLimbAvgTorqImpulse_Propulsn_Frontal_NoFlexTorq', 'SD_Ratio_JointAveragePropulsnTorqueImpulse_Frontal_NoFlexTorq', 'SD_Ratio_JntContrbutn_AvrgTorqImpuls_Front_Propulsn_NoFlexTorq',...
    'SD_Ratio_TotalLimbAvgTorqImpulse_Brkng_Transverse_NoFlexTorq', 'SD_Ratio_JointAverageBrkngTorqueImpulse_Trans_NoFlexTorq', 'SD_Ratio_JntContrbutn_AvrgTorqImpuls_Trans_Brakng_NoFlexTorq',...
    'SD_Ratio_TotalLimbAvgTorqImpulse_Propulsn_Transverse_NoFlexTorq', 'SD_Ratio_JointAveragePropulsnTorqueImpulse_Trans_NoFlexTorq', 'SD_Ratio_JntContrbutn_AvrgTorqImpuls_Trans_Propulsn_NoFlexTorq'};


    %Create a table from the JointBehaviorIndex_GroupMeansPerHoppingRate data and save it as an Excel file
    writetable( array2table( JointPower_ParticipantMeansLimbDiff, 'VariableNames', VariableNames_JointPower_LimbDiff ),...
        'PostQuals_JointPower_BetweenLimbDiff_ParticipantMeans.xlsx' );







    
    
    
%Set variable names for creaitng tables from the JointBehaviorIndex_ParticipantMeansPerRate
 JointBehaviorIndex_RateMeans_VariableNames = {'Group_ID','Participant_ID','Limb_ID','HoppingRate_ID','Trial_ID','Joint_ID','Index_ID','Hop_ID', 'Mean_Index_Value',...
     'Mean_BetweenLimbTendonThickness_mm', 'Mean_VAS_Rating',...
     'SD_Index_Value' };
 %Create a table from the JointBehaviorIndex_ParticipantMeansPerRate data
 JointBehaviorIndex_ParticipantMeansPerRate_Table = array2table(  JointBehaviorIndex_ParticipantMeansPerHoppingRate, 'VariableNames', JointBehaviorIndex_RateMeans_VariableNames );
%Save theJointBehaviorIndex_ParticipantMeansPerRate table as an Excel file    
writetable( JointBehaviorIndex_ParticipantMeansPerRate_Table , 'PostQuals_JointFunctionalIndex_ParticipantMeansPerRate_Table.xlsx' );
    




%Set variable names for creaitng tables from the JointBehaviorIndex_GroupMeansPerHoppingRate
VariableNames_JointBehaviorIndex = {'Group_ID', 'Participant_ID', 'Limb_ID', 'HoppingRate_ID', 'Trial_ID', 'Joint_ID', 'Index_ID', 'Hop_ID', 'Mean_Index_Value',...
     'Mean_BetweenLimbTendonThickness_mm', 'Mean_VAS_Rating',... 
     'SD_Index_Value'};

%Create a table from the JointBehaviorIndex_GroupMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( JointBehaviorIndex_GroupMeansPerHoppingRate, 'VariableNames', VariableNames_JointBehaviorIndex ), 'PostQuals_JointFunctionalIndex_GroupMeansPerHoppingRate.xlsx' );





    
               

VariableNames_JointBehaviorIndex_LimbDiff = { 'Group_ID', 'Participant_ID', 'HoppingRate_ID', 'Joint_ID', 'Index_ID',...
    'Mean_Index_Value_BetweenLimbDiff', 'Mean_Index_Value_BetweenLimbRatio',...
     'Mean_BetweenLimbTendonThickness_mm_BetweenLimbDiff', 'Mean_VAS_Rating_BetweenLimb', 'Mean_VAS_Rating_BetweenLimbRatio'... 
    'SD_Index_Value_BetweenLimbDiff', 'SD_Index_Value_BetweenLimbRatio' };

%Create a table from the JointBehaviorIndex_GroupMeansPerHoppingRate data and save it as an Excel file
writetable( array2table( JointBehaviorIndex_ParticipantMeansLimbDiff, 'VariableNames', VariableNames_JointBehaviorIndex_LimbDiff ),...
    'PostQuals_JointFunctionalIndex_BetweenLimbDiff_ParticipantMeans.xlsx' );





if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 7',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end