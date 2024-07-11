%% SECTION 1 - Load Data Structure
load( 'Post-Quals Data/Data Structure/Current Version/David_DissertationDataStructure_17_Apr_2024.mat');


CreateStruct.Interpreter = 'tex';
CreateStruct.Resize = 'on';
CreateStruct.WindowStyle = 'modal';


lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{18} NO ERRORS IN SECTION 1',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{18}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




 %% SECTION 2 - Create Field Variables

lasterror = [];

%First field within data structure = data for quals versus for remainder of dissertation
QualvsPostQualData = {'Post_Quals'};
%Second field = group list
GroupList_DialogueBox = {'ATx','Control'};
GroupList = { 'ATx', 'Control' };

%Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36', 'ATx49', 'ATx39', 'ATx74', 'ATx65',...
    'ATx14'};
ControlParticipantList = { 'HC05', 'HC06', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45', 'HC44', 'HC48', 'HC65', 'HC67', 'HC68', 'HC30', 'HC31', 'HC32' };

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

%Load the Mass data from the data structure
MassLog = David_DissertationDataStructure.Post_Quals.AllGroups.MassLog;




if isempty( lasterror )
    
    msgbox('\fontsize{18} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{18}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end








%% SECTION 3 - Split GRF Data Up Into Individual Hops



lasterror = [];
    
    %Create a prompt so we can manually enter the group of interest
    FirstTimeRunningCodePrompt = 'Have you entered the group, participant, limb, and rate information before?' ;

    %Use inputdlg function to create a dialogue box for the prompt created above. The second
    %argument 'Executed Code Before' is the title of the dialogue box, while the first argument is
    %the question asked/prompt
    FirstTimeRunningCode_Cell = inputdlg( [ '\fontsize{18}' FirstTimeRunningCodePrompt ], 'Executed Code Before? ', [1 150], {'Yes'} ,CreateStruct);

    %Convert GroupToProcess_Celll into a double
    FirstTimeRunningCode = cell2mat( FirstTimeRunningCode_Cell );

    
    %Use if statement to pop up a prompt asking whether we want to change the group, participant, limb,
    %and rate. Only ask if we said Yes to the above prompt
    if strcmp( FirstTimeRunningCode, 'Yes' )
        
        %Create a prompt so we can manually enter the group of interest
        ChangeVariableIDPrompt = 'Do you want to change Group, Participant, Limb, or HoppingRate? Enter 1, 2, 3, or 4. Otherwise put No';
    
        %Use inputdlg function to create a dialogue box for the prompt created above. The second
        %argument 'Executed Code Before' is the title of the dialogue box, while the first argument is
        %the question asked/prompt
        ChangeVariableID_Cell = inputdlg( [ '\fontsize{18}' ChangeVariableIDPrompt ], 'Do you want to change Group, Participant, Limb, or HoppingRate?', [1 150], {'4'} ,CreateStruct);

        %Convert ChangeVariableID_Cell into a number array
        ChangeVariableID_Numbers = str2num( cell2mat( ChangeVariableID_Cell ) );

    else

        %If we have not entered Group, Participant, Limb or Hopping Rate, set ChangeVariableID_Cell to
        %'No'
         ChangeVariableID_Cell = {'No'};

        %Convert ChangeVariableID_Cell into a number array
        ChangeVariableID_Numbers = str2num( cell2mat( ChangeVariableID_Cell ) );


    end

 


%Data Structure Organization: David_DissertationDataStructure --> Post_Quals -->
    %Group List --> Participant List --> HoppingKinematicsKinetics or EMG --> Limb ID --> 
    % Hopping Rate --> Trial --> Data
for l = 1 : numel( QualvsPostQualData )
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure, QualvsPostQualData{l} );

    
    
    if strcmp( FirstTimeRunningCode, 'No' )
    
    
        %Create a prompt so we can manually enter the group of interest
        GroupToProcessPrompt = [ 'Enter The Group To Process.  ' cell2mat( GroupList ) ];

        %Use inputdlg function to create a dialogue box for the prompt created above
        GroupToProcess_Cell = inputdlg( [ '\fontsize{18}' GroupToProcessPrompt ], 'Enter The Group To Process', [1 150], {'1'} ,CreateStruct);

        %Convert GroupToProcess_Cell into a double
        GroupToProcess = str2double( cell2mat( GroupToProcess_Cell ) );

    %Execute the code below if we want to change the Group ID. Strcmp comparing the
    %ChangeVariableID_Cell and 'Group' should be 1, so sum of the strcmp should be 1. Then pop up the
    %GroupToProcessPrompt to change the group.
    elseif sum( ChangeVariableID_Numbers == 1 ) == 1
    
        %Create a prompt so we can manually enter the group of interest
        GroupToProcessPrompt = [ 'Enter The Group To Process.  ' cell2mat( GroupList ) ];

        %Use inputdlg function to create a dialogue box for the prompt created above
        GroupToProcess_Cell = inputdlg( [ '\fontsize{18}' GroupToProcessPrompt ], 'Enter The Group To Process', [1 150], {'1'} ,CreateStruct);

        %Convert GroupToProcess_Cell into a double
        GroupToProcess = str2double( cell2mat( GroupToProcess_Cell ) );
    
    end
    
    
    
    
%% Begin M For Loop - Loop Through Groups     
    
%Data Structure Organization: David_DissertationDataStructure --> Post_Quals -->
    %Group List --> Participant List --> HoppingKinematicsKinetics or EMG --> Limb ID --> 
    % Hopping Rate --> Trial --> Data
    for m = GroupToProcess
        

        
        
        
        
        
        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
        ParticipantListDataStructure = getfield(GroupListDataStructure, GroupList{m} );
        
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
        
        
        
        
        if strcmp( FirstTimeRunningCode, 'No' )
                
            %Create a prompt so we can manually enter the participant of interest
            ParticipantToProcessPrompt = [ 'Enter The Participant To Process for ' GroupList{m} ' Group.  ' cell2mat( ParticipantList )  ];

            %Use inputdlg function to create a dialogue box for the prompt created above
            ParticipantToProcess_Cell = inputdlg( [ '\fontsize{18}' ParticipantToProcessPrompt ], [ 'Enter The Participant To Process, N = ', num2str( numel( ParticipantList ) ) ], [1 150], {'1'} ,CreateStruct);

            %Convert ParticipantToProcess_Celll into a double
            ParticipantToProcess = str2double( cell2mat( ParticipantToProcess_Cell ) );

    %Execute the code below if we want to change the Participant ID. Strcmp comparing the
    %ChangeVariableID_Cell and 'Participant' should be 1, so sum of the strcmp should be 1. Then pop up the
    %ParticipantToProcessPrompt to change the Participant.
    elseif sum( ChangeVariableID_Numbers == 2 ) == 1
            
        %Create a prompt so we can manually enter the participant of interest
        ParticipantToProcessPrompt = [ 'Enter The Participant To Process for ' GroupList{m} ' Group.  ' cell2mat( ParticipantList )  ];

        %Use inputdlg function to create a dialogue box for the prompt created above
        ParticipantToProcess_Cell = inputdlg( [ '\fontsize{18}' ParticipantToProcessPrompt ], [ 'Enter The Participant To Process, N = ', num2str( numel( ParticipantList ) ) ], [1 150], {'1'} ,CreateStruct);

        %Convert ParticipantToProcess_Celll into a double
        ParticipantToProcess = str2double( cell2mat( ParticipantToProcess_Cell ) );
        
        end
        
        
%% Begin N For Loop - Loop Through Participants          
        
        for n = ParticipantToProcess
            

            %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %tables, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{ n }, 'ATx07'  ) || strcmp( ParticipantList{ n }, 'ATx08'  ) || strcmp( ParticipantList{ n }, 'ATx10'  ) || strcmp( ParticipantList{ n }, 'ATx17'  ) ||...
                    strcmp( ParticipantList{ n }, 'ATx18'  ) || strcmp( ParticipantList{ n }, 'ATx19'  ) || strcmp( ParticipantList{ n }, 'ATx21'  ) || strcmp( ParticipantList{ n }, 'ATx25'  ) ||...
                    strcmp( ParticipantList{ n }, 'ATx36'  ) || strcmp( ParticipantList{ n }, 'ATx38'  ) || strcmp( ParticipantList{ n }, 'ATx39'  ) || strcmp( ParticipantList{ n }, 'ATx41'  ) ||...
                    strcmp( ParticipantList{ n }, 'ATx49'  ) ||strcmp( ParticipantList{ n }, 'ATx74'  ) || strcmp( ParticipantList{ n }, 'ATx65'  )
             
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                
                
                
            elseif strcmp( ParticipantList{ n }, 'ATx12'  )  || strcmp( ParticipantList{ n }, 'ATx14'  )  || strcmp( ParticipantList{ n }, 'ATx24'  ) || strcmp( ParticipantList{ n }, 'ATx27'  ) ||...
                    strcmp( ParticipantList{ n }, 'ATx34'  ) || strcmp( ParticipantList{ n }, 'ATx44'  )  || strcmp( ParticipantList{ n }, 'ATx50'  ) 
                
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                

                
            else
                
                LimbID = {'LeftLimb','RightLimb'};
                
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
            end


            %If participant being processed is ATx01, we only collected on the medial gastroc on the
            %right limb. Otherwise, we collected on both limbs.
%             if strcmp( ParticipantList{ n }, 'ATx01'  )
% 
% 
%                 HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
%                 
%                 
%                 GRFSampHz = 1500;
%                 EMGSampHz = 1500;
%                 MoCapSampHz = 300;
% 
%                 
%             elseif strcmp(  ParticipantList{ n }, 'HP03'  )
% 
%                 
%                 HoppingRate_ID = {'TwoPoint3Hz'};
%                 
%                 
%                 GRFSampHz = 2500;
%                 EMGSampHz = 1500;
%                 MoCapSampHz = 250;
% 
%                 
%            elseif strcmp(  ParticipantList{ n }, 'HP08'  )
% 
%                
%                HoppingRate_ID = {'TwoPoint2Hz', 'TwoPoint3Hz'};
%                
%                GRFSampHz = 1500;
%                 EMGSampHz = 1500;
%                 MoCapSampHz = 150;
%                 
%             end
            

            HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
            
            
            %Data Structure Organization: David_DissertationDataStructure --> Post_Quals -->
            %Group List --> Participant List --> HoppingKinematicsKinetics or EMG --> Limb ID --> 
            % Hopping Rate --> Trial --> Data
            ListofDataTypes_DataStructure = getfield(ParticipantListDataStructure,ParticipantList{ n });
            
            
            ParticipantNMass = round( MassLog.Mass_kg( strcmp(  ParticipantList{ n } , MassLog.Participant_ID ) ), 2 );
            ParticipantNWeight = ParticipantNMass.*9.81;
            
            
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ n }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ n }, 'HP02' )
                
                MoCapSampHz = 300;
                
                
            else
                
                MoCapSampHz = 250;
                
            end
            
            


            
            for o = 1 : numel(DataCategories_HoppingKinematicsKinetics)
                
                %Use get field to create a new data structure containing the list of limbs. Stored under the 4th field of the structure (the list of data categories)
                Listof_LimbIDsforIndexing_DataStructure = getfield(ListofDataTypes_DataStructure, DataCategories_HoppingKinematicsKinetics{o} );
                
                
                
                
                if strcmp( FirstTimeRunningCode, 'No' )
                
                    %Create a prompt so we can manually enter the limbt of interest
                    LimbToProcessPrompt = [ 'Enter The Limb To Process for ' ParticipantList{ n } ' '  cell2mat( LimbID )  ];

                    %Use inputdlg function to create a dialogue box for the prompt created above
                    LimbToProcess_Cell = inputdlg( [ '\fontsize{18}' LimbToProcessPrompt ], 'Enter The Limb To Process', [1 150], {'1'} ,CreateStruct);

                    %Convert LimbToProcess_Cell into a double
                    LimbToProcess = str2double( cell2mat( LimbToProcess_Cell ) );

                %Execute the code below if we want to change the Limb ID. Strcmp comparing the
                %ChangeVariableID_Cell and 'Limb' should be 1, so sum of the strcmp should be 1. Then pop up the
                %LimbToProcessPrompt to change the Limb.
                elseif sum( ChangeVariableID_Numbers == 3 ) == 1
                
                    %Create a prompt so we can manually enter the limbt of interest
                    LimbToProcessPrompt = [ 'Enter The Limb To Process for ' ParticipantList{ n } ' '  cell2mat( LimbID )  ];

                    %Use inputdlg function to create a dialogue box for the prompt created above
                    LimbToProcess_Cell = inputdlg( [ '\fontsize{18}' LimbToProcessPrompt ], 'Enter The Limb To Process', [1 150], {'1'} ,CreateStruct);

                    %Convert LimbToProcess_Cell into a double
                    LimbToProcess = str2double( cell2mat( LimbToProcess_Cell ) );
                
                end
                
                
                
                
%% Begin A For Loop - Loop Through Limbs          


                for a = LimbToProcess
                    
                    
                    ListofHoppingRates_DataStructure = getfield(Listof_LimbIDsforIndexing_DataStructure, LimbID{ a } );


                    HoppingTrialNumber = {'Trial1'};

                        
                        FirstDataPointofFlight = NaN(1, length( HoppingTrialNumber ) );
                        LastDataPointofFlight = NaN(1, length( HoppingTrialNumber ) );


                        FirstDataPointofGContact = NaN(1, length( HoppingTrialNumber ) );
                        LastDataPointofGContact = NaN(1, length( HoppingTrialNumber ) );


                        FirstDataPointofHop = NaN(1, length( HoppingTrialNumber ) );
                        LastDataPointofHop = NaN(1, length( HoppingTrialNumber ) );


                        LengthofFlightPhase = NaN(1, length( HoppingTrialNumber ) );
                        LengthofContactPhase = NaN(1, length( HoppingTrialNumber ) );
                        
                        
                        
                        
                        if strcmp( FirstTimeRunningCode, 'No' )
                        
                            %Create a prompt so we can manually enter the hopping rate of interest
                            HoppingRateToProcessPrompt = [ 'Enter The Hopping Rate To Process for ' ParticipantList{ n } '   '  LimbID{a} '   '  cell2mat(HoppingRate_ID )  ];

                            %Use inputdlg function to create a dialogue box for the prompt created above
                            HoppingRateToProcess_Cell = inputdlg( [ '\fontsize{18}' HoppingRateToProcessPrompt ], 'Enter The Hopping Rate To Process', [1 150], {'1'} ,CreateStruct);

                            %Convert LimbToProcess_Cell into a double
                            HoppingRateToProcess = str2double( cell2mat( HoppingRateToProcess_Cell ) );

                        %Execute the code below if we want to change the Hopping Rate ID. Strcmp comparing the
                        %ChangeVariableID_Cell and 'HoppingRate' should be 1, so sum of the strcmp should be 1. Then pop up the
                        %HoppingRateToProcessPrompt to change the Hopping Rate.
                        elseif sum( ChangeVariableID_Numbers == 4 ) == 1
                        
                            %Create a prompt so we can manually enter the hopping rate of interest
                            HoppingRateToProcessPrompt = [ 'Enter The Hopping Rate To Process for ' ParticipantList{ n } '   '  LimbID{a} '   '  cell2mat(HoppingRate_ID )  ];

                            %Use inputdlg function to create a dialogue box for the prompt created above
                            HoppingRateToProcess_Cell = inputdlg( [ '\fontsize{18}' HoppingRateToProcessPrompt ], 'Enter The Hopping Rate To Process', [1 150], {'1'} ,CreateStruct);

                            %Convert LimbToProcess_Cell into a double
                            HoppingRateToProcess = str2double( cell2mat( HoppingRateToProcess_Cell ) );
                                
                        
                        end
                        
                        
                        
%% Begin B For Loop - Hopping Rate                        
                        
                        for b = HoppingRateToProcess
                        

                            ListofHoppingTrials = getfield( ListofHoppingRates_DataStructure, HoppingRate_ID{b} );
                            

                            
                            
                            %Initialize variables GContactBegin and GContactEnd
                            GContactBegin = NaN(4,numel(HoppingTrialNumber));
                            GContactEnd = NaN(4,numel(HoppingTrialNumber));

                            %Initialize variables 
                            GContactBegin_MedianHop = NaN(numel(HoppingTrialNumber),1);
                            GContactBegin_Indices = NaN(1,numel(HoppingTrialNumber));
                            GContactBegin_Frames = NaN(1,numel(HoppingTrialNumber));

                            %Initalize variables
                            GContactEnd_Indices = NaN(11,numel(HoppingTrialNumber));
                            GContactEnd_FrameNumbers = NaN(11,numel(HoppingTrialNumber));

                            %Initalize variables
                            LengthofFlightPhase_NonTruncated_GRFSamplingHz = NaN(1,numel(HoppingTrialNumber));
                            LengthofContactPhase_GRFSamplingHz = NaN(1,numel(HoppingTrialNumber));
                            LengthofEntireHop_GRFSamplingHz = NaN(1,numel(HoppingTrialNumber));
                            LengthofEntireHop_NonTruncated_GRFSamplingHz = NaN(1,numel(HoppingTrialNumber));

                            %Initalize variables
                            LengthofContactPhase_SthHop_GRFSampHz = NaN(1,numel(HoppingTrialNumber));                            
                            
                            %Initalize variables
                            HoppingRateAnalysis = NaN( 1,numel(HoppingTrialNumber));            
                            
                            %Initalize variables
                            FirstDataPoint_SthHop_Truncated = NaN( 1,numel(HoppingTrialNumber));            
                            
                            %Initalize variables
                            LengthofFlightPhase_NonTruncated_MoCapSampHz = NaN( 1,numel(HoppingTrialNumber));      
                            LengthofFlightPhase_Truncated_MoCapSampHz = NaN( 1,numel(HoppingTrialNumber));      
                            LengthofContactPhase_MoCapSampHz = NaN( 1,numel(HoppingTrialNumber));      
                            LengthofEntireHop_NonTruncated_MoCapSampHz = NaN( 1,numel(HoppingTrialNumber));      
                            LengthofEntireHop_Truncated_MoCapSampHz = NaN( 1,numel(HoppingTrialNumber));      
                            
                            
                            %Initalize variables
                            LengthofFlightPhase_EMGSampHz = NaN( 1,numel(HoppingTrialNumber));      
                            LengthofContactPhase_EMGSampHz = NaN( 1,numel(HoppingTrialNumber));      
                            LengthofHop_EMGSampHz = NaN( 1,numel(HoppingTrialNumber));      

                            
%% Begin Q For Loop - Hopping Trial Number         
                            

                            
                            for q = 1 : numel(HoppingTrialNumber)


                                 %Initialize variables to hold individual hops for vertical, AP, and
                                 %ML GRF
                                vGRF_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                vGRF_IndividualHops_Normalized = NaN(4,numel(HoppingTrialNumber));
                                
                                MLGRF_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                MLGRF_IndividualHops_Normalized = NaN(4,numel(HoppingTrialNumber));

                                APGRF_IndividualHops = NaN(4,numel(HoppingTrialNumber));
                                APGRF_IndividualHops_Normalized = NaN(4,numel(HoppingTrialNumber));

                                %Initialize variable to hold the length of each hop cycle
                                LengthofEntireHop_Truncated_GRFSamplingHz = NaN(4,1);

                                
                                MLGRF_IndividualHops_ContactPhase = NaN(3,numel(HoppingTrialNumber));
                                APGRF_IndividualHops_ContactPhase = NaN(3,numel(HoppingTrialNumber));
                                vGRF_IndividualHops_ContactPhase = NaN(3,numel(HoppingTrialNumber));

                                
                                MLGRF_IndividualHops_ContactPhase_Normalized = NaN(3,numel(HoppingTrialNumber));
                                APGRF_IndividualHops_ContactPhase_Normalized = NaN(3,numel(HoppingTrialNumber));
                                vGRF_IndividualHops_ContactPhase_Normalized = NaN(3,numel(HoppingTrialNumber));

                                HopHeight_mm = NaN(1);
                                HopHeight_cm = NaN(1);
                                HopsWithDissimilarHeight = NaN(1);
                                HopsWithSimilarHeight_Indices = NaN(1);
                                DeviationfromAverageHopHeight_AllHopsOnFP = NaN(1);
                                HopsWithDissimilarHeight_AllHopsOnFP_Indices = NaN(1);
                                HopsWithSimilarHeight_AllHopsOnFP_Indices = NaN(1);

                                
                                %Create variables containing the tables for the pth trial
                                HoppingTrialP_OriginalDataTable = getfield(ListofHoppingTrials, HoppingTrialNumber{q} );
                                %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});

                                
                                
                                
                                %Create temporary vector containing the frame. Do this because there may be a
                                %different number of hops in each trial.
                                [GContactBegin_TemporaryVector, GContactEnd_TemporaryVector] = CalculateBeginningAndEndOfHopCycle(HoppingTrialP_OriginalDataTable.FP3_2);

                                
                                
                                
                                
                                %Want to know the number of hops in the pth trial. Number of hops may differ
                                %between trials.
                                NumberofRows_GContactEnd = numel(GContactEnd_TemporaryVector);
                                NumberofRows_GContactBegin = numel(GContactBegin_TemporaryVector);

                                
                                
                                
                                
                                %Store the frames corresponding to the beginning and end of each hop in the
                                %correct number of rows for the pth trial.
                                GContactBegin(1:NumberofRows_GContactBegin,q) = GContactBegin_TemporaryVector;
                                GContactEnd(1:NumberofRows_GContactEnd,q) = GContactEnd_TemporaryVector;

                                
%                                 if strcmp( FirstTimeRunningCode, 'No' )
%                                 
%                                     %Create a prompt so we can decide whether to continue script
%                                     %execution. Will only do this if there are no extreme differences in
%                                     %flight or contact phase durations across all hops
%                                     ContinueScriptPrompt = [ 'Need to Check GContactBegin/End? for ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ];
% 
%                                     %Use inputdlg function to create a dialogue box for the prompt created above
%                                     ContinueScript_Cell = inputdlg( [ '\fontsize{18}' ContinueScriptPrompt  ], 'Need to Check GContactBegin/End? Enter No if Have Already Checked GContactBegin/End for Errors', [1 150], {'No'} ,CreateStruct);
% 
%                                     %If there are extreme differences
%                                     if strcmp( ContinueScript_Cell{ 1 }, 'Yes' )
% 
%                                         return
% 
%                                     end
%                                     
%                                 end
                                
                                
                                
                                
%% Check GContactBegin and End Data Points                                
                                
                                %Only run the code below if this is the first time entering demographic
                                %info OR if we have already entered the necessary demographic info and
                                %are changing some of it
                                if ~strcmp( ChangeVariableID_Cell, 'No' ) || strcmp( FirstTimeRunningCode, 'No' )

                                    figure('Color','#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name', ['Check GContactBegin and End Data Points  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ] )
                                    
                                    sgtitle( ['Check GContactBegin and End Data Points  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ], 'FontSize', 20 )
                                    
                                    subplot( 2, 1, 1)
                                    plot( GContactBegin, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 20 )
                                    set( gca, 'FontSize', 16)
                                    title( 'Check GContact Begin Data Points', 'FontSize', 16 )
                                    xlabel( 'Data Point #', 'FontSize', 16 )
                                    ylabel( 'Frame #', 'FontSize', 16 )
                                    
                                    
                                    subplot( 2, 1, 2)
                                    plot( GContactEnd, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 20 )
                                    set( gca, 'FontSize', 16)
                                    title( 'Check GContact End Data Points', 'FontSize', 16 )
                                    xlabel( 'Data Point #', 'FontSize', 16 )
                                    ylabel( 'Frame #', 'FontSize', 16 )
                                    
                                    %Create pop-up dialog box displaying the first value in GContactEnd
                                    MSGBox1 = msgbox( { [ '\fontsize{20} First Ground Contact End Value is ', num2str( GContactEnd( 1 ) ), ' for ', ParticipantList{ n }, '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q}  ]   }, CreateStruct);
            
                                    %Don't execute the next line of code until user responds to dialog box above
                                    uiwait( MSGBox1 )
                                    
                                    %Create pop-up dialog box displaying the first value in GContactEnd
                                    MSGBox2 = msgbox( { [ '\fontsize{20} First Ground Contact Begin Value is ', num2str( GContactBegin( 1 ) ), ' for ', ParticipantList{ n }, '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q}  ]   }, CreateStruct);
            
                                    %Don't execute the next line of code until user responds to dialog box above
                                    uiwait( MSGBox2 )
                                    
                                    pause
                                    
                                    close all
                                
                                

                                
                                
                                    %Create a prompt so we can manually enter the participant of interest
                                    FirstGContactEndPrompt = ( 'Enter The First GContactEnd Point To Use' );
    
                                    %Use inputdlg function to create a dialogue box for the prompt created above
                                    FirstGContactEnd_Cell = inputdlg( [ '\fontsize{18}' FirstGContactEndPrompt ], 'Enter The First GContactEnd Point To Use', [1 150], {'1'} ,CreateStruct);
    
                                    %Convert FirstGContactEnd_Cell into a double
                                    FirstGContactEnd = str2double( cell2mat( FirstGContactEnd_Cell ) );
                                
                                
                                
                                
                                    %Create a prompt so we can manually enter the participant of interest
                                    FirstGContactBeginPrompt = ( 'Enter The First GContactBegin Point To Use' );
    
                                    %Use inputdlg function to create a dialogue box for the prompt created above
                                    FirstGContactBegin_Cell = inputdlg( [ '\fontsize{18}' FirstGContactBeginPrompt ], 'Enter The First GContactBegin Point To Use', [1 150], {'1'} ,CreateStruct);
    
                                    %Convert FirstGContactEnd_Cell into a double
                                    FirstGContactBegin = str2double( cell2mat( FirstGContactBegin_Cell ) );


                                else
                                    

                                end
                                

                                
                                
                                %For ATx10, Involved Limb, 2.3 Hz, the first GContactEnd came AFTER
                                %the first GContactBegin. Tell the code to eliminate the first X
                                %GContactBeginPoinnts
                                if FirstGContactBegin ~= 1
                                    
                                    GContactBegin = GContactBegin( FirstGContactBegin : end );
                                    
                                    
                                end
                                
                                
                                
                                
                                %How many hops are there before we cut any?
                                OriginalNumberofHops = length( GContactEnd( FirstGContactEnd : end ) ) -1;
                                
                                %Save the original GContactEnd frames in case we need to double check
                                %after removing hops
                                OriginalHopsToUse_GContactEndFrames = GContactEnd( FirstGContactEnd : end );

                                %Save the original GContactBegin frames in case we need to double check
                                %after removing hops
                                OriginalHopsToUse_GContactBeginFrames = GContactBegin;
                                

                                %Find hopping rate for each hop. This is 1 / time in seconds
                                for z = 1 : OriginalNumberofHops
                                    
                                    %Need to subtract 1 from the Z+1 end of ground
                                    %contact frame, because end of ground contact is defined as beginning
                                    %of flight phase.
                                    HoppingRateAnalysis( z ) = 1 ./ ( length( HoppingTrialP_OriginalDataTable.FP3_2( OriginalHopsToUse_GContactEndFrames( z ) : (OriginalHopsToUse_GContactEndFrames( z+1 ) - 1 ) ) ) ./ GRFSampHz );
                                    
                                end
                                    
                                


 %% PLOT INDIVIDUAL HOPPING RATES 
 
                                %Only run the code below If we have already entered the necessary demographic info and aren't
                                %changing it OR if this is the first time entering demographic info
                                 if ~isempty( ChangeVariableID_Cell ) || strcmp( FirstTimeRunningCode, 'No' )

                                    %Plot the HoppingRateAnalysis data to visualize the rate for each
                                    %hop
                                    figure('Color','#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name', ['Check Hopping Rate  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ] )
                                    
                                    plot( HoppingRateAnalysis, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 20 )
                                    set( gca, 'FontSize', 16)
                                    title( ['Check Hopping Rate  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ], 'FontSize', 18 )
                                    xlabel( 'Data Point #', 'FontSize', 16 )
                                    ylabel( 'Hopping Rate (Hz)', 'FontSize', 16 )
                                   
                                    
                                    %Create a horizontal line to show the average hopping rate
                                    L = line( [ 1 length( HoppingRateAnalysis ) ], [ mean( HoppingRateAnalysis ), mean( HoppingRateAnalysis ) ] );
                                    L.LineWidth = 2;
                                    L.LineStyle = '--';
                                    
                                    %Create pop-up dialog box displaying the value of minimum power absorption AND generation
                                    MSGBox1 = msgbox( { [ '\fontsize{18} Average Hopping Rate is ',  num2str( mean( HoppingRateAnalysis ) ) ]; [ 'SD of Hopping Rate is ', num2str( std( HoppingRateAnalysis ) ) ] }  ,CreateStruct);
    
                                    %Don't execute the next line of code until user responds to dialog box above
                                    uiwait( MSGBox1 )

                                    savefig( [ ParticipantList{ n }, '_', 'HoppingRate', '_', LimbID{a} ' _ ' HoppingRate_ID{b}, '.fig' ] );
                                    
                                    pause

                                    close all

                                 end
                                
                                
                                
                                
                                
                                
                                %If we're processing the preferred hopping rate, our 'target'
                                %hopping rate is the average hopping rate
                                if strcmp( HoppingRate_ID{b}, 'PreferredHz' )
                                
                                    %Want to see how far each hop is away from the average hopping
                                    %rate. Will want to pick hops as close as possible to the
                                    %average
                                    DeviationfromHoppingRate = HoppingRateAnalysis - mean( HoppingRateAnalysis );
                                    
                                %If we're processing the 2 Hz hopping rate, our 'target' hopping rate is the prescribed Hz    
                                elseif strcmp( HoppingRate_ID{b}, 'TwoHz' )
                                    
                                    %Want to see how far each hop is away from the average hopping
                                    %rate. Will want to pick hops as close as possible to the
                                    %average
                                    DeviationfromHoppingRate = HoppingRateAnalysis - 2;
                                    
                                    
                                %If we're processing the 2.3 Hz hopping rate, our 'target' hopping rate is the prescribed Hz    
                                elseif strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )
                                    
                                    %Want to see how far each hop is away from the average hopping
                                    %rate. Will want to pick hops as close as possible to the
                                    %average
                                    DeviationfromHoppingRate = HoppingRateAnalysis - 2.3;
                                
                                end
                                
                                
                                

                                
                                
                                
%% PLOT DEVIATIONS FROM TARGET HOPPING HZ                          


                                %Only run the code below If we have already entered the necessary demographic info and aren't
                                %changing it OR if this is the first time entering demographic info
                                 if ~isempty( ChangeVariableID_Cell ) || strcmp( FirstTimeRunningCode, 'No' )

                                    %Plot the deviation of each hop from the average preferred Hz or the
                                    %target Hz
                                    figure('Color','#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name', ['Check Deviations from Target Hopping Hz  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ] )
                                    
                                    plot( DeviationfromHoppingRate, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 20 )
                                    set( gca, 'FontSize', 16)
                                    title( ['Check Deviations from Target Hopping Hz  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ], 'FontSize', 18 )
                                    xlabel( 'Data Point #', 'FontSize', 16 )
                                    ylabel( 'Deviation (Hz)', 'FontSize', 16 )
                                    ylim( [ -0.3, 0.3 ] )
                                    
                                    %Create a horizontal line at 0 to represent the ideal deviation from
                                    %the target hopping rate
                                    L = line( [ 1 length( HoppingRateAnalysis ) ], [ 0 0 ] );
                                    L.LineWidth = 2;
                                    L.LineStyle = '--';
                                    
                                    %Create a vertical line at Hop 5 - will only take hops after Hop 5
                                    L2 = line( [ 5, 5 ], [ -0.25, 0.25 ] );
                                    L2.LineWidth = 2;
                                    L2.LineStyle = '--';
                                    L2.Color = 'm';
                                    
                                    %Create a vertical line at the 4th to last - will only take hops
                                    %before this hop
                                    L3 = line( [ length(DeviationfromHoppingRate) - 4, length( DeviationfromHoppingRate ) - 4 ], [ -0.25, 0.25 ] );
                                    L3.LineWidth = 2;
                                    L3.LineStyle = '--';
                                    L3.Color = 'm';
                                    
                                    %Create a horizontal line at 0.1 Hz - won't take hops with a
                                    %deviation above 0.1 Hz
                                     L4 = line( [ 1, length( DeviationfromHoppingRate )  ], [ 0.1, 0.1 ] );
                                    L4.LineWidth = 2;
                                    L4.LineStyle = '--';
                                    L4.Color = 'r';
                                    
                                    %Create a horizontal line at -0.1 Hz - won't take hops with a
                                    %deviation above 0.1 Hz
                                     L5 = line( [ 1, length( DeviationfromHoppingRate )  ], [ -0.1, -0.1 ] );
                                    L5.LineWidth = 2;
                                    L5.LineStyle = '--';
                                    L5.Color = 'r';

                                    savefig( [ ParticipantList{ n }, '_', 'DeviationFromTargetHoppingHz', '_', LimbID{a} ' _ ' HoppingRate_ID{b},  '.fig' ] );

                                    pause

                                    close all

                                 end
                                
                                
                                
%% Find the GContactEnd and GContactBegin Data Points to Use  
% 
%                                 %Create a prompt so we can manually enter the participant of interest
%                                 GContactEndToUsePrompt = [ 'Enter The GContactEnd Points To Use for ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ];
% 
%                                 %Use inputdlg function to create a dialogue box for the prompt created above
%                                 GContactEndToUse_Cell = inputdlg( [ '\fontsize{18}' GContactEndToUsePrompt  ], 'Enter The GContactEnd Points To Use. Separate with spaces.', [1 150], {'1'} ,CreateStruct);



                                %When screening for off-force plate hops, remove the first 5 and last 5
                                %hops. This allows the participant to get into the 'rhythm' and avoids
                                %the 
                                RemoveFirst5andLast5Hops = 6 : ( numel( OriginalHopsToUse_GContactEndFrames  ) - 5 );
                                
                                %Pull out the GContactEnd values to use
                                GContactEndFramesToUse_BeginFlightPhase = OriginalHopsToUse_GContactEndFrames( RemoveFirst5andLast5Hops );
                                
                                
                                
                                
                                
                                %The GContactBegin data points to use should be the like-numbered
                                %ones in GContactEndToUseForFlightPhase
                                GContactBeginDataPointsToUse_OriginalHopNumber = RemoveFirst5andLast5Hops;
                                
                                %Pull out the GContactBegin values to use.
                                GContactBeginFramesToUse = OriginalHopsToUse_GContactBeginFrames( GContactBeginDataPointsToUse_OriginalHopNumber );
                                
                                
                                %These are the frame numbers to use to end the contact phase. Will use these to
                                %create a time series for contact phase only. Note that these are
                                %NOT the same as GContactEndFramesforFlightPhase.
                                %GContactEndFramesforFlightPhase are simply used for defining the
                                %BEGINNING of flight phase. 
                                GContactEndFramesToUse_ToEndGContact = OriginalHopsToUse_GContactEndFrames( RemoveFirst5andLast5Hops+1 );
                                

                                %Create pop-up dialog box displaying the value of minimum power absorption AND generation
                                MSGBox1 = msgbox( { [ '\fontsize{20} Original Number of Hops =  ', num2str( numel( GContactEndFramesToUse_ToEndGContact ) )  ' --- ', ParticipantList{ n }, ' -- ' LimbID{a} ' -- ' HoppingRate_ID{b} ' -- ' HoppingTrialNumber{q}  ]   }  , CreateStruct);
        
                                %Don't execute the next line of code until user responds to dialog box above
                                uiwait( MSGBox1 )



%% Remove Hops Where Foot Is Off Force Plate


                            %Find the X and Y coordinates for the Lab Origin
                            FP3_LabOrigin_X = HoppingTrialP_OriginalDataTable.FP3_LabOrigin( 1 );
                            FP3_LabOrigin_Y = -0.03;


                            %Find the X and Y coordinates for the Force Plate Anterior-Right Corner
                            %Marker
                            FP3_AnteriorRightCorner_X = HoppingTrialP_OriginalDataTable.FP3_AnteriorRightCorner( 1 );
                            FP3_AnteriorRightCorner_Y = HoppingTrialP_OriginalDataTable.FP3_AnteriorRightCorner_1( 1 );


                            %Find the X and Y coordinates for the malleolus, metatarsal heads, and rear
                            %foot markers. Use if statement because the names of the markers change based
                            %on the right versus left limbs
                            if strcmp( LimbID_forV3DOutput{ a }, 'LeftLimb' )

                                if strcmp( ParticipantList{ n }, 'ATx25' )

                                    %Medial malleolus
                                    MedMal_X = HoppingTrialP_OriginalDataTable.LFF1;
                                    MedMal_Y = HoppingTrialP_OriginalDataTable.LFF1_1;


                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.LFF2;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.LFF2_1;


                                elseif strcmp( ParticipantList{ n }, 'ATx18' ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )

                                    %Medial malleolus
                                    MedMal_X = HoppingTrialP_OriginalDataTable.LMeMAL;
                                    MedMal_Y = HoppingTrialP_OriginalDataTable.LMeMAL_1;

                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.LLaMAL;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.LLaMAL_1;


                                elseif strcmp( ParticipantList{ n }, 'HC20' ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )

                                    %Medial malleolus
                                    MedMal_X = HoppingTrialP_OriginalDataTable.LFF1;
                                    MedMal_Y = HoppingTrialP_OriginalDataTable.LFF1_1;

                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.LFF2;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.LFF2_1;


                                else

                                    %Medial malleolus
                                    MedMal_X = HoppingTrialP_OriginalDataTable.LMeMAL;
                                    MedMal_Y = HoppingTrialP_OriginalDataTable.LMeMAL_1;


                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.LFF2;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.LFF2_1;

                                end



                                %Lateral malleolus
                                LatMal_X = HoppingTrialP_OriginalDataTable.LLaMAL;
                                LatMal_Y = HoppingTrialP_OriginalDataTable.LLaMAL_1;

                                %MetHead 1
                                MetHead1_X = HoppingTrialP_OriginalDataTable.LFF1;
                                MetHead1_Y = HoppingTrialP_OriginalDataTable.LFF1_1;

                                %Distal Foot
                                DistalFoot_X = HoppingTrialP_OriginalDataTable.LFF3;
                                DistalFoot_Y = HoppingTrialP_OriginalDataTable.LFF3_1;

                                %Top Rearfoot marker
                                TopRearFoot_X = HoppingTrialP_OriginalDataTable.LRF2;
                                TopRearFoot_Y = HoppingTrialP_OriginalDataTable.LRF2_1;

                                %Bottom Rearfoot marker
                                BottomRearFoot_X = HoppingTrialP_OriginalDataTable.LRF3;
                                BottomRearFoot_Y = HoppingTrialP_OriginalDataTable.LRF3_1;

                                %Lateral Rearfoot marker
                                LatRearFoot_X = HoppingTrialP_OriginalDataTable.LRF1;
                                LatRearFoot_Y = HoppingTrialP_OriginalDataTable.LRF1_1;


                            elseif strcmp( LimbID_forV3DOutput{ a }, 'RightLimb' )

                                %Medial malleolus
                                MedMal_X = HoppingTrialP_OriginalDataTable.RMeMAL;
                                MedMal_Y = HoppingTrialP_OriginalDataTable.RMeMAL_1;

                                if strcmp( ParticipantList{ n }, 'ATx12' )

                                    %Lateral malleolus
                                    LatMal_X = HoppingTrialP_OriginalDataTable.RFF1;
                                    LatMal_Y = HoppingTrialP_OriginalDataTable.RFF1_1;


                                    %Lateral Rearfoot marker
                                    LatRearFoot_X = HoppingTrialP_OriginalDataTable.RFF1;
                                    LatRearFoot_Y = HoppingTrialP_OriginalDataTable.RFF1_1;


                                    %Top Rearfoot marker
                                    TopRearFoot_X = HoppingTrialP_OriginalDataTable.RRF1;
                                    TopRearFoot_Y = HoppingTrialP_OriginalDataTable.RRF1_1;

                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.RFF2;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.RFF2_1;


                                elseif strcmp( ParticipantList{ n }, 'ATx18' ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )


                                    %Lateral malleolus
                                    LatMal_X = HoppingTrialP_OriginalDataTable.RLaMAL;
                                    LatMal_Y = HoppingTrialP_OriginalDataTable.RLaMAL_1;

                                    %Lateral Rearfoot marker
                                    LatRearFoot_X = HoppingTrialP_OriginalDataTable.RRF2;
                                    LatRearFoot_Y = HoppingTrialP_OriginalDataTable.RRF2_1;

                                    %Top Rearfoot marker
                                    TopRearFoot_X = HoppingTrialP_OriginalDataTable.RRF1;
                                    TopRearFoot_Y = HoppingTrialP_OriginalDataTable.RRF1_1;

                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.RLaMAL;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.RLaMAL_1;


                                elseif strcmp( ParticipantList{ n }, 'ATx25' )

                                    %Lateral malleolus
                                    LatMal_X = HoppingTrialP_OriginalDataTable.RLaMAL;
                                    LatMal_Y = HoppingTrialP_OriginalDataTable.RLaMAL_1;

                                    %Lateral Rearfoot marker
                                    LatRearFoot_X = HoppingTrialP_OriginalDataTable.RFF1;
                                    LatRearFoot_Y = HoppingTrialP_OriginalDataTable.RFF1_1;


                                    %Top Rearfoot marker
                                    TopRearFoot_X = HoppingTrialP_OriginalDataTable.RRF3;
                                    TopRearFoot_Y = HoppingTrialP_OriginalDataTable.RRF3_1;

                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.RFF2;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.RFF2_1;


                                else

                                    %Lateral malleolus
                                    LatMal_X = HoppingTrialP_OriginalDataTable.RLaMAL;
                                    LatMal_Y = HoppingTrialP_OriginalDataTable.RLaMAL_1;

                                    %Lateral Rearfoot marker
                                    LatRearFoot_X = HoppingTrialP_OriginalDataTable.RRF2;
                                    LatRearFoot_Y = HoppingTrialP_OriginalDataTable.RRF2_1;

                                    %Top Rearfoot marker
                                    TopRearFoot_X = HoppingTrialP_OriginalDataTable.RRF1;
                                    TopRearFoot_Y = HoppingTrialP_OriginalDataTable.RRF1_1;

                                    %MetHead 5
                                    MetHead5_X = HoppingTrialP_OriginalDataTable.RFF2;
                                    MetHead5_Y = HoppingTrialP_OriginalDataTable.RFF2_1;

                                end



                                %MetHead 1
                                MetHead1_X = HoppingTrialP_OriginalDataTable.RFF1;
                                MetHead1_Y = HoppingTrialP_OriginalDataTable.RFF1_1;

                                %Distal Foot
                                DistalFoot_X = HoppingTrialP_OriginalDataTable.RFF3;
                                DistalFoot_Y = HoppingTrialP_OriginalDataTable.RFF3_1;

                                %Bottom Rearfoot marker
                                BottomRearFoot_X = HoppingTrialP_OriginalDataTable.RRF3;
                                BottomRearFoot_Y = HoppingTrialP_OriginalDataTable.RRF3_1;

                            end



                            %Use these to tell the below If statement
                            %which row of the variables to fill
                            RowtoFill_HopsOffFP = 1;
                            RowtoFill_HopsOnFP = 1;

                             %Initialize the variables used in the below
                            %If statement
                            HopsOffFP_Indices = NaN(1);
                            HopsOnFP_Indices = NaN(1);
                            OffFPMarkerCoordinates_AllHops = NaN(length( GContactBeginDataPointsToUse_OriginalHopNumber ), 2);


                            %Each iteration is 1 hop. Use this to figure out if markers pass outside
                            %the force plate boundaries
                            for z = 1 : length( GContactBeginDataPointsToUse_OriginalHopNumber )


                                %Convert GContactBegin frames from GRF Samp Hz to MoCap Samp Hz. Need
                                %to use ceil so that MoCap frames ar whole numbers.
                                OriginalHopsToUse_GContactBegin_MoCapFrames = ceil( OriginalHopsToUse_GContactBeginFrames ./ 1500 .* 250 );


                                %Convert GContactEnd frames from GRF Samp Hz to MoCap Samp Hz. Need
                                %to use ceil so that MoCap frames ar whole numbers.
                                OriginalHopsToUse_GContactEnd_MoCapFrames = ceil( OriginalHopsToUse_GContactEndFrames ./ 1500 .* 250 );

                                %Find all frames for the ground contact phase of Hop Z
                                FramesforGContactPhase_HopZ_MoCapFrames = OriginalHopsToUse_GContactBegin_MoCapFrames( GContactBeginDataPointsToUse_OriginalHopNumber ( z ) )  :  OriginalHopsToUse_GContactEnd_MoCapFrames( GContactBeginDataPointsToUse_OriginalHopNumber ( z ) + 1 ) - 1;

                                %Initialize matrix to hold X and Y coordinates of markers that
                                %indicate the foot is off the FP
                                OffFPMarkerIndices = NaN( numel( FramesforGContactPhase_HopZ_MoCapFrames ) , 2);


                                
                                %Run loop once for each frame of the ground contact phase
                                for y = 1 : numel( FramesforGContactPhase_HopZ_MoCapFrames )

                                    %If we are processing the Left Limb, execute the indented code
                                    if strcmp( LimbID_forV3DOutput{ a }, 'LeftLimb' )

                                        %If either the medial malleolus or 1st met head are outside the right boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        if MedMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= FP3_AnteriorRightCorner_X || MetHead1_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= FP3_AnteriorRightCorner_X

                                            HopsOffFP_Indices( RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;

                                            %If the medial malleolus marker is farther past the
                                            %FP3_AnteriorRightCorner X coordinate than the 1st Met Head, store the medial
                                            %malleolus X and Y coordiantes
                                            if MedMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) > MetHead1_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) )

                                                OffFPMarkerIndices( y, 1 ) = MedMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = MedMal_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            %If the 1st Met Head marker is farther past the
                                            %FP3_AnteriorRightCorner X coordinate than the medial malleolus marker, store the
                                            % Met Head 1 marker X and Y coordiantes
                                            else

                                                OffFPMarkerIndices( y, 1 ) = MetHead1_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = MetHead1_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            end

                                            y = numel( FramesforGContactPhase_HopZ_MoCapFrames ) + 1;


                                        %If the distal rearfoot marker is outside the anterior boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        elseif DistalFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= FP3_AnteriorRightCorner_Y

                                            HopsOffFP_Indices(RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;

                                            %Store the distal foot marker X and Y coordiantes
                                            OffFPMarkerIndices( y, 1 ) = DistalFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                            OffFPMarkerIndices( y, 2 ) = DistalFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            y = numel( FramesforGContactPhase_HopZ_MoCapFrames ) + 1;


                                        %If the lateral malleolus, 5th met head, or lateral
                                        %rear foot markers are outside the left boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        elseif LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_X || MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_X %|| LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_X

                                            HopsOffFP_Indices(RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;
                                            
                                            %If the lateral malleolus marker is farther past the
                                            %FP3_LabOrigin X coordinate than the 5th Met Head and Lateral RearFoot, store the lateral
                                            %malleolus X and Y coordinates
                                            if LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) < MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) %&& LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) )

                                                OffFPMarkerIndices( y, 1 ) = LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = LatMal_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            %If the 5th Met Head marker is farther past the
                                            %FP3_LabOrigin X coordinate than the lateral malleolus marker and Lateral Rearfoot, store the
                                            % Met Head 5 marker X and Y coordiantes
                                            else%if MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) < LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) && MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) )

                                                OffFPMarkerIndices( y, 1 ) = MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = MetHead5_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            %If the Lateral Rearfoot marker is farther past the
                                            %FP3_LabOrigin X coordinate than the lateral malleolus marker and 5th Met Head, store the
                                            % Lateral Rearfoot marker X and Y coordiantes
%                                                 else 
% 
%                                                     OffFPMarkerIndices( y, 1 ) = LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
%                                                     OffFPMarkerIndices( y, 2 ) = LatRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );


                                            end

                                            y = numel( FramesforGContactPhase_HopZ_MoCapFrames ) + 1;


                                        %If either the top rearfoot or bottom rearfoot markers are outside the posterior boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        elseif TopRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_Y || BottomRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_Y

                                            HopsOffFP_Indices(RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;
                                            
                                            %If the Top Rearfoot marker is farther past the
                                            %FP3_LabOrigin Y coordinate than the Bottom Rearfoot, store the Top Rearfoot
                                            % X and Y coordinates
                                            if TopRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) < BottomRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) 

                                                OffFPMarkerIndices( y, 1 ) = TopRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = TopRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            %If the Bottom Rearfoot marker is farther past the
                                            %FP3_LabOrigin Y coordinate than the Top Rearfoot, store the Bottom Rearfoot
                                            % X and Y coordinates
                                            else

                                                OffFPMarkerIndices( y, 1 ) = BottomRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = BottomRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            end

                                            y = numel( FramesforGContactPhase_HopZ_MoCapFrames ) + 1;




                                        end%End if statement for finding which marker (if any) passes the force plate boundaries


                                    %If we are processing the Left Limb, execute the indented code
                                    elseif strcmp( LimbID_forV3DOutput{ a }, 'RightLimb' )

                                        %If the lateral malleolus, 5th met head, or lateral
                                        %rear foot markers are outside the right boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        if LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= FP3_AnteriorRightCorner_X || MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= FP3_AnteriorRightCorner_X  || LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= FP3_AnteriorRightCorner_X


                                            HopsOffFP_Indices(RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;
                                            
                                            %If the lateral malleolus marker is farther past the
                                            %FP3_LabOrigin X coordinate than the 5th Met Head and Lateral RearFoot, store the lateral
                                            %malleolus X and Y coordinates
                                            if LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) && LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) )

                                                OffFPMarkerIndices( y, 1 ) = LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = LatMal_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            %If the 5th Met Head marker is farther past the
                                            %FP3_LabOrigin X coordinate than the lateral malleolus marker and Lateral Rearfoot, store the
                                            % Met Head 5 marker X and Y coordiantes
                                            elseif MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) > LatMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) && MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) )

                                                OffFPMarkerIndices( y, 1 ) = MetHead5_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = MetHead5_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            %If the Lateral Rearfoot marker is farther past the
                                            %FP3_LabOrigin X coordinate than the lateral malleolus marker and 5th Met Head, store the
                                            % Lateral Rearfoot marker X and Y coordiantes
                                            else 

                                                OffFPMarkerIndices( y, 1 ) = LatRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = LatRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );


                                            end


                                        
                                        %If the distal rearfoot marker is outside the anterior boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        elseif DistalFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) >= FP3_AnteriorRightCorner_Y

                                            HopsOffFP_Indices(RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;

                                            %Store the distal foot marker X and Y coordiantes
                                            OffFPMarkerIndices( y, 1 ) = DistalFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                            OffFPMarkerIndices( y, 2 ) = DistalFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );




                                        %If either the medial malleolus or 1st met head are outside the left boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        elseif MedMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_X || MetHead1_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_X

                                            HopsOffFP_Indices(RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;


                                            %If the medial malleolus marker is farther past the
                                            %FP3_AnteriorRightCorner X coordinate than the 1st Met Head, store the medial
                                            %malleolus X and Y coordiantes
                                            if MedMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) < MetHead1_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) )

                                                OffFPMarkerIndices( y, 1 ) = MedMal_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = MedMal_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            %If the 1st Met Head marker is farther past the
                                            %FP3_AnteriorRightCorner X coordinate than the medial malleolus marker, store the
                                            % Met Head 1 marker X and Y coordiantes
                                            else

                                                OffFPMarkerIndices( y, 1 ) = MetHead1_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                                OffFPMarkerIndices( y, 2 ) = MetHead1_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );

                                            end



                                        %If either the top rearfoot or bottom rearfoot markers are outside the posterior boundary of the
                                        %force plate, store Hop Z in HopsOffFP_Indices
                                        elseif BottomRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_Y %|| TopRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) <= FP3_LabOrigin_Y

                                            HopsOffFP_Indices(RowtoFill_HopsOffFP) = z;

                                            RowtoFill_HopsOffFP = RowtoFill_HopsOffFP + 1;

                                            OffFPMarkerIndices( y, 1 ) = BottomRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                            OffFPMarkerIndices( y, 2 ) = BottomRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
                                            
%                                                 %If the Top Rearfoot marker is farther past the
%                                                 %FP3_LabOrigin Y coordinate than the Bottom Rearfoot, store the Top Rearfoot
%                                                 % X and Y coordinates
%                                                 if TopRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) < BottomRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) ) 
% 
%                                                     OffFPMarkerIndices( y, 1 ) = TopRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
%                                                     OffFPMarkerIndices( y, 2 ) = TopRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
% 
%                                                 %If the Bottom Rearfoot marker is farther past the
%                                                 %FP3_LabOrigin Y coordinate than the Top Rearfoot, store the Bottom Rearfoot
%                                                 % X and Y coordinates
%                                                 else
% 
%                                                     OffFPMarkerIndices( y, 1 ) = BottomRearFoot_X( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
%                                                     OffFPMarkerIndices( y, 2 ) = BottomRearFoot_Y( FramesforGContactPhase_HopZ_MoCapFrames ( y ) );
% 
%                                                 end
                                            


                                        end%End If statement


                                        

                                    end%End If statement for determining whether we are processing the right versus left limb

                                end%End the Y For Loop

                                


                                %Use this to pull out the X and Y marker coordinates for the
                                %marker that is farthest outside the force plate boundaries.
                                %If all markers are inside the force plate boundaries, fill
                                %in OffFPMarkerCoordinates_AllHops wih NaNs
                                if sum( isnan( OffFPMarkerIndices( :, 1 ) ) ) == numel( FramesforGContactPhase_HopZ_MoCapFrames )

                                     OffFPMarkerCoordinates_AllHops( z, 1 ) = NaN;
                                    OffFPMarkerCoordinates_AllHops( z, 2 ) = NaN;            

                                    HopsOnFP_Indices(RowtoFill_HopsOnFP) = z;

                                    RowtoFill_HopsOnFP = RowtoFill_HopsOnFP + 1;
                                    
                                %If the marker that is furthest  outside the force plate is
                                %past the anterior or posterior boundary, store the X and Y
                                %coordinates for that marker
                                elseif max( abs( OffFPMarkerIndices( :, 1 ) ), [], 'omitnan' ) < max( abs( OffFPMarkerIndices( :, 2 ) ), [], 'omitnan' )

                                    MaxCoordinateIndex = find( abs( OffFPMarkerIndices( :, 2 ) ) == max( abs( OffFPMarkerIndices( :, 2 ) ) ), 1, 'first' );

                                    OffFPMarkerCoordinates_AllHops( z, 1 ) = OffFPMarkerIndices( MaxCoordinateIndex, 1 );
                                    OffFPMarkerCoordinates_AllHops( z, 2 ) = OffFPMarkerIndices( MaxCoordinateIndex, 2 );

                                %If the marker that is furthest  outside the force plate is
                                %past the medial or lateral boundary, store the X and Y
                                %coordinates for that marker
                                elseif max( abs( OffFPMarkerIndices( :, 1 ) ), [], 'omitnan' ) >= max( abs( OffFPMarkerIndices( :, 2 ) ), [], 'omitnan' )

                                    MaxCoordinateIndex = find( abs( OffFPMarkerIndices( :, 1 ) ) == max( abs( OffFPMarkerIndices( :, 1 ) ) ), 1, 'first' );

                                    OffFPMarkerCoordinates_AllHops( z, 1 ) = OffFPMarkerIndices( MaxCoordinateIndex, 1 );
                                    OffFPMarkerCoordinates_AllHops( z, 2 ) = OffFPMarkerIndices( MaxCoordinateIndex, 2 );


                                end%End if statement for finding which marker (if any) passes the force plate boundaries

                            end%End the Z for loop



                            %Remove all repeats from HopsOnFP_Indices
                            HopsOnFP_Indices = unique( HopsOnFP_Indices );
                            HopsOffFP_Indices = unique( HopsOffFP_Indices );


                            %If there are hops to remove, there will  be at least one NaN in HopsOnFP_Indices. Replace all 
                            % NaNs with 0s and find the numbers of the hops on the force plate
                            if sum( isnan( HopsOnFP_Indices ) ) ~= 1

                                %Set the indices for NaNs to 0
                                HopsOnFP_Indices( isnan( HopsOnFP_Indices) ) = 0;

                                if sum( isnan( HopsOffFP_Indices ) ) ~= 1

                                    %Find the numbers of the hops off the force plate
                                    GContactBeginDataPointsToNOTUse_OriginalHopNumber = GContactBeginDataPointsToUse_OriginalHopNumber( HopsOffFP_Indices );

                                else

                                    GContactBeginDataPointsToNOTUse_OriginalHopNumber = NaN( 1 );

                                end

                                %Find the numbers of the hops on the force plate
                                GContactBeginDataPointsToUse_OriginalHopNumber = GContactBeginDataPointsToUse_OriginalHopNumber( HopsOnFP_Indices );



                                %Pull out the GContactEnd values to use,
                                %based on which hops are vertical hops
                                GContactEndFramesToUse_BeginFlightPhase = OriginalHopsToUse_GContactEndFrames( GContactBeginDataPointsToUse_OriginalHopNumber );

                                %Pull out the GContactBegin values to use,
                                %based on which hops are vertical hops
                                GContactBeginFramesToUse = OriginalHopsToUse_GContactBeginFrames( GContactBeginDataPointsToUse_OriginalHopNumber );

                                %These are the frame numbers to use to end the contact phase. Will use these to
                                %create a time series for contact phase only. Note that these are
                                %NOT the same as GContactEndFramesforFlightPhase.
                                %GContactEndFramesforFlightPhase are simply used for defining the
                                %BEGINNING of flight phase.
                                GContactEndFramesToUse_ToEndGContact = OriginalHopsToUse_GContactEndFrames( GContactBeginDataPointsToUse_OriginalHopNumber + 1 );

                                  %Store the DeviationFromHoppingRate only for hops with a contact phase length similar to that for the average contact
                                %phase length
                                DeviationfromHoppingRate = DeviationfromHoppingRate( GContactBeginDataPointsToUse_OriginalHopNumber );

                            end

                            %HopsOffFP_Indices is initialized with 1 NaN. If there are no hops off FP,
                            %pop up a message saying 0 hops off FP. Can't use numel because the number of
                            %elements is 1 NaN
                            if isnan( HopsOffFP_Indices )
                                
                                %Create pop-up dialog box displaying the value of minimum power absorption AND generation
                                MSGBox1 = msgbox( { [ '\fontsize{20} Number of Hops Off FP =  0 --- ', ParticipantList{ n }, ' -- ' LimbID{a} ' -- ' HoppingRate_ID{b} ' -- ' HoppingTrialNumber{q}  ]   }  , CreateStruct);
        
                                %Don't execute the next line of code until user responds to dialog box above
                                uiwait( MSGBox1 )

                            %If there actually were hops off the FP, pop up a message with the number of hops off the FP    
                            else

                                %Create pop-up dialog box displaying the value of minimum power absorption AND generation
                                MSGBox1 = msgbox( { [ '\fontsize{20} Number of Hops Off FP =  ', num2str( numel( HopsOffFP_Indices ) )  ' --- ', ParticipantList{ n }, ' -- ' LimbID{a} ' -- ' HoppingRate_ID{b} ' -- ' HoppingTrialNumber{q}  ]   }  , CreateStruct);
        
                                %Don't execute the next line of code until user responds to dialog box above
                                uiwait( MSGBox1 )

                            end
                            



%% Check Removal of Off-FP Hops

                                %Plot the AP and M-L displacements. Want to make
                                %sure there are no hops that violate the
                                %maximum tolerable amount
                                figure('Color','#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',...
                                    ['Check Removal Hops Outside FP Boundaries  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ] )
                                
                                plot( FP3_LabOrigin_X, FP3_LabOrigin_Y, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 35, 'MarkerFaceColor', 'r' )
                                
                                hold on
                                plot( FP3_AnteriorRightCorner_X, FP3_AnteriorRightCorner_Y, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 35, 'MarkerFaceColor', 'r' )
                                plot( OffFPMarkerCoordinates_AllHops( :, 1), OffFPMarkerCoordinates_AllHops( :, 2 ), 'LineStyle', 'none', 'Marker', 'o', 'MarkerSize', 20, 'MarkerFaceColor', '#003b6f', 'MarkerEdgeColor', 'w' )

                                L = line( [FP3_LabOrigin_X, FP3_AnteriorRightCorner_X ], [FP3_AnteriorRightCorner_Y, FP3_AnteriorRightCorner_Y] );
                                L.LineWidth = 2;
                                L.LineStyle = '--';
                                L.Color = 'r';

                                L2 = line( [FP3_LabOrigin_X, FP3_AnteriorRightCorner_X ], [FP3_LabOrigin_Y, FP3_LabOrigin_Y] );
                                L2.LineWidth = 2;
                                L2.LineStyle = '--';
                                L2.Color = 'r';

                                L3 = line( [FP3_LabOrigin_X, FP3_LabOrigin_X ], [FP3_AnteriorRightCorner_Y, FP3_LabOrigin_Y] );
                                L3.LineWidth = 2;
                                L3.LineStyle = '--';
                                L3.Color = 'r';

                                L4 = line( [FP3_AnteriorRightCorner_X, FP3_AnteriorRightCorner_X ], [FP3_AnteriorRightCorner_Y, FP3_LabOrigin_Y] );
                                L4.LineWidth = 2;
                                L4.LineStyle = '--';
                                L4.Color = 'r';

                                text( 0.38,0.44, 'Anterior -Right Corner', 'FontSize', 17)
                                text( 0.0024, 0.01, 'Posterior-Left Corner', 'FontSize', 17)

                                hold off
                                ylabel( 'Marker X-Coordinates (m)', 'FontSize', 16 )
                                ylabel( 'Marker Y-Coordinates (m)', 'FontSize', 16 )
                                ylim( [ -1, 1] )
                                xlim( [ -1, 1] )
                                title('Check Removal of Hops Outside FP Boundaries', 'FontSize', 18)

                                savefig( [ ParticipantList{ n }, '_', 'OffFPHops', '_', LimbID{a} ' _ ' HoppingRate_ID{b},  '.fig' ] );
                                

                                pause


                                close all



%% Remove Hops Based on M-L or A-P Displacement                                
                                
                              %Had a version where I removed hops based on excessive M-L or A-P
                              %displacement. I removed that, so just set a high threshold to ensure hops
                              %aren't removed.
                                MaxMLDisplacement = 0.3;
                                MaxAPDisplacement = 0.3;
                                
                                %Use these to tell the below If statement
                                %which row of the variables to fill
                                RowtoFill_NonVerticalHops = 1;
                                RowtoFill_VerticalHops = 1;

                                 %Initialize the variables used in the below
                                %If statement
                                NonVerticalHops = NaN(1);
                                VerticalHops_Indices = NaN(1);
                                MLDisplacement_HopZ = NaN( length( GContactBeginDataPointsToUse_OriginalHopNumber ), 1 );
                                APDisplacement_HopZ = NaN( length( GContactBeginDataPointsToUse_OriginalHopNumber ), 1 );



                                %Each iteration is 1 hop. Calculate length of flight and ground
                                %contact phases
                                for z = 1 : length( GContactBeginDataPointsToUse_OriginalHopNumber )
                                    
                                    %Find time of peak vGRF for Hop Z-1
                                    TimeofPeakvGRF_HopZMinus1_GRFFrames = find( HoppingTrialP_OriginalDataTable.FP3_2( OriginalHopsToUse_GContactBeginFrames ( GContactBeginDataPointsToUse_OriginalHopNumber( z )- 1 )  :  OriginalHopsToUse_GContactEndFrames( GContactBeginDataPointsToUse_OriginalHopNumber( z ) ) ) ==...
                                        max( HoppingTrialP_OriginalDataTable.FP3_2( OriginalHopsToUse_GContactBeginFrames ( GContactBeginDataPointsToUse_OriginalHopNumber( z )- 1 )  :  OriginalHopsToUse_GContactEndFrames( GContactBeginDataPointsToUse_OriginalHopNumber( z ) ) ) ), 1, 'first' ) +...
                                        OriginalHopsToUse_GContactBeginFrames ( GContactBeginDataPointsToUse_OriginalHopNumber( z )- 1 ) - 1;

                                    %Find time of peak vGRF for Hop Z
                                    TimeofPeakvGRF_HopZ_GRFFrames = find( HoppingTrialP_OriginalDataTable.FP3_2( OriginalHopsToUse_GContactBeginFrames ( GContactBeginDataPointsToUse_OriginalHopNumber( z ) )  :  OriginalHopsToUse_GContactEndFrames( GContactBeginDataPointsToUse_OriginalHopNumber( z ) + 1 ) ) ==...
                                        max( HoppingTrialP_OriginalDataTable.FP3_2( OriginalHopsToUse_GContactBeginFrames ( GContactBeginDataPointsToUse_OriginalHopNumber( z ) )  :  OriginalHopsToUse_GContactEndFrames( GContactBeginDataPointsToUse_OriginalHopNumber( z ) + 1 ) ) ), 1, 'first' ) +...
                                        OriginalHopsToUse_GContactBeginFrames ( GContactBeginDataPointsToUse_OriginalHopNumber( z ) ) - 1;

                                    %Find the M-L displacement of Hop Z and store in MLDisplacement_HopZ.
                                    %Calculation = difference between M-L location of COP at time of peak vGRF for Hop Z vs 
                                    % Hop Z-1
                                    MLDisplacement_HopZ( z ) = HoppingTrialP_OriginalDataTable.COFP( TimeofPeakvGRF_HopZ_GRFFrames ) -...
                                        HoppingTrialP_OriginalDataTable.COFP( TimeofPeakvGRF_HopZMinus1_GRFFrames );

                                    %Find the A-P displacement of Hop Z and store in MLDisplacement_HopZ.
                                    %Calculation = difference between M-L location of COP at time of peak vGRF for Hop Z vs 
                                    % Hop Z-1
                                    APDisplacement_HopZ( z ) = HoppingTrialP_OriginalDataTable.COFP_1( TimeofPeakvGRF_HopZ_GRFFrames ) -...
                                        HoppingTrialP_OriginalDataTable.COFP_1( TimeofPeakvGRF_HopZMinus1_GRFFrames );


                                        %Remove the hop if the COP displaces
                                        %more than the tolerable amount.
                                        if abs(MLDisplacement_HopZ( z) ) > MaxMLDisplacement || abs(APDisplacement_HopZ( z )) > MaxAPDisplacement
    
                                            NonVerticalHops(RowtoFill_NonVerticalHops) = z;
    
                                            RowtoFill_NonVerticalHops = RowtoFill_NonVerticalHops + 1;
    
                                        elseif abs(MLDisplacement_HopZ( z) ) <= MaxMLDisplacement && abs(APDisplacement_HopZ( z )) <= MaxAPDisplacement
    
                                            VerticalHops_Indices(RowtoFill_VerticalHops) = z;
    
                                            RowtoFill_VerticalHops = RowtoFill_VerticalHops + 1;
    
                                        end



                                        %If the number of chosen hops is less than 7, run this code to
                                        %add back the hops with the lowest M-L and A-P displacements
                                        if z == length( GContactBeginDataPointsToUse_OriginalHopNumber ) && length( GContactBeginDataPointsToUse_OriginalHopNumber ) > 6 && numel( VerticalHops_Indices ) < 7 && isempty( NonVerticalHops )

                                            %Run this code until we have 7 usable hops
                                            while numel( VerticalHops_Indices ) < 7

                                                %Find the lowest A-P displacement among the removed hops
                                                MinAPDisplacement = min( abs( APDisplacement_HopZ( NonVerticalHops ) ) );

                                                %Find the lowest M-L displacement among the removed hops
                                                MinMLDisplacement = min( abs( MLDisplacement_HopZ( NonVerticalHops ) ) );

                                                %If the minimum A-P displacement is smaller than the
                                                %minimum M-L displacement, run the indented code
                                                if MinAPDisplacement < MinMLDisplacement

                                                    %Find the hop with the minimum AP displacement
                                                    HopToAdd = find( abs( APDisplacement_HopZ( NonVerticalHops ) ) == MinAPDisplacement, 1, 'first'  );

                                                    %Find which hop in NonVerticalHops will be added back in
                                                    NumberofRemovedHopToUse = NonVerticalHops( HopToAdd );
                                                
                                                    %Add the hop with the minimum AP displacement into the
                                                    %usable hops
                                                    VerticalHops_Indices( RowtoFill_VerticalHops ) = NumberofRemovedHopToUse;

                                                    %Delete the used hop from Removed Hops. Prevents that
                                                    %hop
                                                    %from being used again
                                                    NonVerticalHops( HopToAdd  ) = [];

                                                    %Add 1 to RowtoFill_UsableHops
                                                    RowtoFill_VerticalHops = RowtoFill_VerticalHops + 1;

                                                %If the minimum M-L displacement is smaller than the
                                                %minimum A-P displacement, run the indented code
                                                elseif MinAPDisplacement >= MinMLDisplacement

                                                    %Find the hop with the minimu ML displacement
                                                    HopToAdd = find( abs( MLDisplacement_HopZ( NonVerticalHops ) ) == MinMLDisplacement, 1, 'first'  );

                                                    %Find which hop in NonVerticalHops will be added back in
                                                    NumberofRemovedHopToUse = NonVerticalHops( HopToAdd );
                                                
                                                    %Add the hop with the minimum AP displacement into the
                                                    %usable hops
                                                    VerticalHops_Indices( RowtoFill_VerticalHops ) = NumberofRemovedHopToUse;

                                                    %Delete the used hop from Removed Hops. Prevents that
                                                    %hop
                                                    %from being used again
                                                    NonVerticalHops( HopToAdd  ) = [];

                                                    %Add 1 to RowtoFill_UsableHops
                                                    RowtoFill_VerticalHops = RowtoFill_VerticalHops + 1;

                                                end

                                            end

                                        %If there are fewer than 7 hops before removing those with A-P and M-L displacement, use all hops and don't remove any    
                                        elseif z == length( GContactBeginDataPointsToUse_OriginalHopNumber ) && length( GContactBeginDataPointsToUse_OriginalHopNumber ) < 7 &&...
                                                numel( VerticalHops_Indices ) < 7 && isempty( NonVerticalHops )

                                                VerticalHops_Indices = VerticalHops_Indices;

                                        end

                                    
                                end



                                %Sort VerticalHops_Indices so hops are in ascending order
                                VerticalHops_Indices = sort( VerticalHops_Indices );




%% Plot A-P and M-L Displacements

                                %Plot the AP and M-L displacements. Want to make
                                %sure there are no hops that violate the
                                %maximum tolerable amount
                                figure('Color','#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',...
                                    ['Check COP A-P and M-L  Displacement  ' ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ] )
                                
                                %Plot length of contact phase
                                subplot( 2, 1, 1)
                                plot( abs(MLDisplacement_HopZ), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 20, 'MarkerFaceColor', '#003b6f' )
                                hold on
                                L = line( [0 numel(MLDisplacement_HopZ ) ], [MaxMLDisplacement, MaxMLDisplacement] );
                                L.LineWidth = 2;
                                L.LineStyle = '--';
                                L.Color = 'k';
                                hold off
                                xlabel( 'Data Point #', 'FontSize', 16 )
                                ylabel( 'Displacement', 'FontSize', 16 )
                                title('COP M-L Displacement', 'FontSize', 18)
                                
                                %Plot length of flight phase
                                subplot( 2, 1, 2)
                                plot( abs(APDisplacement_HopZ), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 20, 'MarkerFaceColor', '#003b6f' )
                                hold on
                                L = line( [0 numel(MLDisplacement_HopZ ) ], [MaxAPDisplacement, MaxAPDisplacement] );
                                L.LineWidth = 2;
                                L.LineStyle = '--';
                                L.Color = 'k';
                                hold off
                                xlabel( 'Data Point #', 'FontSize', 16 )
                                ylabel( 'Displacement', 'FontSize', 16 )
                                title('COP A-P Displacement', 'FontSize', 18)
                                
                                pause

                                close all



%% Manually Remove Hops, If Necessary

                            

                                %Create a prompt so we can tell the code if we need to manually remove other hops
                                RemoveHopsPrompt = 'Need To Manually Remove Hops? Yes/Y or No/N.' ;
                        
                                %Use inputdlg function to create a dialogue box for the prompt created above
                                RemoveHops_Cell = inputdlg( [ '\fontsize{20}' RemoveHopsPrompt ], 'Need To Manually Remove Hops?', [1 150], {'No'} ,CreateStruct);

                                %Only execute the code below if we told the code we need to manually
                                %remove prompts
                                if strcmp( RemoveHops_Cell, 'Yes' ) || strcmp( RemoveHops_Cell, 'Y' )
    
                                    %Create a prompt so we can manually remove other hops
                                    RemoveHopsPrompt = [ 'Enter Hops To Remove, 1 - ', num2str( VerticalHops_Indices ) , '. 0 for no hops to remove, leave blank to stop code. ' ];
                            
                                    %Use inputdlg function to create a dialogue box for the prompt
                                    %created above. Hop number = based on 1 to number of hops remaining,
                                    %not the original hop number
                                    RemoveHops_Cell = inputdlg( [ '\fontsize{20}' RemoveHopsPrompt ], 'Enter Hops To Remove', [1 150], {' '} ,CreateStruct);

                                end



                                %Save the original vertical hops for easier reference
                                VerticalHops_Original = VerticalHops_Indices;
                        
                                %Only remove values if RemoveHops_Cell is not empty
                                if strcmp( cell2mat( RemoveHops_Cell ), ' ' ) 

                                    return

                                elseif strcmp( cell2mat( RemoveHops_Cell ), '0' )

                                    VerticalHops_Indices = VerticalHops_Indices;

                                else

                                    %Convert GroupToProcess_Cell into a double
                                    HopsToRemove = str2num( cell2mat( RemoveHops_Cell ) );
    
                                    %Remove the specified hops
                                    VerticalHops_Indices( HopsToRemove ) = [];

                                end








                                %Find the numbers of the vertical hops
                                VerticalHops = GContactBeginDataPointsToUse_OriginalHopNumber( VerticalHops_Indices );

                                %Create pop-up dialog box displaying the hop numbers of the vertical
                                %hops
                                MSGBox3 = msgbox( { [ '\fontsize{20} Vertical Hop Numbers are ', num2str( VerticalHops ), ' for ', ParticipantList{ n }, '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q}  ]   }, CreateStruct);
        
                                %Don't execute the next line of code until user responds to dialog box above
                                uiwait( MSGBox3 )




                                %Create pop-up dialog box displaying the hop numbers of the vertical
                                %hops
                                MSGBox4 = msgbox( { [ '\fontsize{20} Number of Hops = ', num2str( numel( VerticalHops ) ), ' for ', ParticipantList{ n }, '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q}  ]   }, CreateStruct);
        
                                %Don't execute the next line of code until user responds to dialog box above
                                uiwait( MSGBox4 )



                                %Pull out the GContactEnd values to use,
                                %based on which hops are vertical hops
                                GContactEndFramesToUse_BeginFlightPhase = OriginalHopsToUse_GContactEndFrames( VerticalHops );

                                %Pull out the GContactBegin values to use,
                                %based on which hops are vertical hops
                                GContactBeginFramesToUse = OriginalHopsToUse_GContactBeginFrames ( VerticalHops );

                                %These are the frame numbers to use to end the contact phase. Will use these to
                                %create a time series for contact phase only. Note that these are
                                %NOT the same as GContactEndFramesforFlightPhase.
                                %GContactEndFramesforFlightPhase are simply used for defining the
                                %BEGINNING of flight phase.
                                GContactEndFramesToUse_ToEndGContact = OriginalHopsToUse_GContactEndFrames( VerticalHops + 1 );

                                


                                %Each iteration is 1 hop. Calculate length of flight and ground
                                %contact phases
                                for z = 1 : length( VerticalHops )
                                    
                                    %Find the length of the Zth flight phase and store in
                                    %LengthofFlightPhase_GRFSamplingHz.
                                    LengthofFlightPhase_NonTruncated_GRFSamplingHz( z ) = length( GContactEndFramesToUse_BeginFlightPhase( z ) : ( GContactBeginFramesToUse( z ) - 1 ) );
                                    
                                    %Find the length of the Zth contact phase and store in
                                    %LengthofContactPhase_GRFSamplingHz. Need to subtract 1 from the Zth
                                    %GContactEndPoint_ToEndGContact, because end of contact is defined as
                                    %beginning of flight phase
                                    LengthofContactPhase_GRFSamplingHz( z ) = length( GContactBeginFramesToUse( z ) : ( GContactEndFramesToUse_ToEndGContact( z ) - 1 )    );
                                    
                                    %Find the length of the Zth hop cycle and store in
                                    %LengthofHop_EntireCycle. Need to subtract 1 from the Zth
                                    %GContactEndPoint_ToEndGContact, because end of contact is defined as
                                    %beginning of flight phase
                                    LengthofEntireHop_NonTruncated_GRFSamplingHz( z ) = length( GContactEndFramesToUse_BeginFlightPhase( z ) :  ( GContactEndFramesToUse_ToEndGContact( z ) - 1 )   );
                                    
                                end
                                
                                
                                
                                

                                %Find the minimum length of the flight phase for the Qth trial of 10 hops
                                MinLengthofFlightPhase_GRFSamplingHz = min( LengthofFlightPhase_NonTruncated_GRFSamplingHz );
                                
                                
                                %Lenngth of flight phase is now set to the minimum length of the
                                %flight phase. This should make the length equal across all hops and
                                %hops are now synchronized to ground contact
                                LengthofFlightPhase_Truncated_GRFSamplingHz( :, : ) = MinLengthofFlightPhase_GRFSamplingHz;
                                
                                %Find the trunated length of flight phase, in seconds
                                LengthofFlightPhase_Truncated_Seconds = LengthofFlightPhase_Truncated_GRFSamplingHz ./ GRFSampHz;

                                




                                
  %% Find GContact Data Points for Calculating Hopping Height       
        


                                %Initialize vector to hold the element numbers of OriginalHopsToUse_GContactEndFrames that equals
                                %the values of GContactEndPoints_ToEndGContactGContactBegin
                                GContactEndDataPointsToUseForFlightPhase_forHeight = NaN( numel( GContactEndFramesToUse_ToEndGContact ), 1);

                                %To calculate hop height, we'll need to look at the flight phase
                                %after the ground contact phase ends. This corresponds to
                                %GContactEndPoints_ToEndGContact
                                for z = 1 : numel( GContactEndFramesToUse_ToEndGContact )

                                    %Find the element number of OriginalHopsToUse_GContactEndFrames that equals
                                    %the ath value of GContactEndPoints_ToEndGContact
                                    GContactEndDataPointsToUseForFlightPhase_forHeight( z ) = find( OriginalHopsToUse_GContactEndFrames == GContactEndFramesToUse_ToEndGContact( z ) );
                                
                                end

                                

                                %Pull out the GContactEnd values to use
                                GContactEndFramesforFlightPhase_forHeight = OriginalHopsToUse_GContactEndFrames( GContactEndDataPointsToUseForFlightPhase_forHeight );

                                
                                
                                %The GContactBegin data points for calculating hopping height should be the like-numbered
                                %ones in GContactEndToUseForFlightPhase
                                GContactBeginDataPointsToUse_forHeight = GContactEndDataPointsToUseForFlightPhase_forHeight;
                                

                                 %Pull out the GContactBegin values to use.
                                GContactBeginFrames_forHeight = OriginalHopsToUse_GContactBeginFrames ( GContactBeginDataPointsToUse_forHeight );
        
                                
                                %Find the GContactEnd frames to use for calculating hopping height,
                                %but in motion capture sampling Hz. Do this by dividing
                                %GContactEndFramesforFlightPhase_forHeight by GRF sampling Hz, then
                                %multiply by motion capture sampling Hz. Use ceil() because we can't
                                %take a partial frame (ex: if result is Frame 1024.2, we'll take
                                %Frame 1025). Then use round() to get rid of any weird number
                                %formats that might give us errors.
                                GContactEndFramesforFlightPhase_forHeight_MoCapSampHz = round( ceil( ( GContactEndFramesforFlightPhase_forHeight ./ GRFSampHz ) .* MoCapSampHz ) );
                                
                                
                                 %Find the GContactBegin frames to use for calculating hopping height,
                                %but in motion capture sampling Hz. Do this by dividing
                                %GContactBeginFramesforFlightPhase_forHeight by GRF sampling Hz, then
                                %multiply by motion capture sampling Hz. Use ceil() because we can't
                                %take a partial frame (ex: if result is Frame 1024.2, we'll take
                                %Frame 1025). Then use round() to get rid of any weird number
                                %formats that might give us errors.
                                GContactBeginFramesforFlightPhase_forHeight_MoCapSampHz = round( ceil( ( GContactBeginFrames_forHeight ./ GRFSampHz ) .* MoCapSampHz ) );



                                %ATx25 is missing L5-S1 marker for Involved Limb, 2.3 Hz. Use LPSIS
                                %instead
                                if strcmp( ParticipantList{ n }, 'ATx25' ) && strcmp( LimbID{a}, 'InvolvedLimb' ) && strcmp( HoppingRate_ID{ b }, 'TwoPoint3Hz' )

                                    %Each iteration is 1 hop. Calculate hop height
                                    for z = 1 : length( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz )
                                        
                                        %Find vertical position of L5-S1 marker at end of ground contact
                                        %phase
                                        L5S1_VerticalPosition_EndofContactPhase = HoppingTrialP_OriginalDataTable.LPSIS_2 (GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z )  );
    
                                        %Find maximum vertical position of L5-S1 during flight phase
                                        L5S1_MaxVerticalPosition = max( HoppingTrialP_OriginalDataTable.LPSIS_2( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z ) : GContactBeginFramesforFlightPhase_forHeight_MoCapSampHz( z ) ) );
    
                                        %Find hop height, in mm
                                        HopHeight_mm( z ) =(  L5S1_MaxVerticalPosition - L5S1_VerticalPosition_EndofContactPhase ) .* 1000;
                                        
                                    end


                                %ATx65 had poor L5-S1 tracking. Use RPSIS instead, for Involved Limb 2.0 and 2.33 Hz Hopping. Will also use for Non-Involved Limb 2.33 Hz Hopping    
                                elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{a}, 'InvolvedLimb' ) && ~strcmp( HoppingRate_ID{ b }, 'PreferredHz' )

                                    %Each iteration is 1 hop. Calculate hop height
                                    for z = 1 : length( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz )
                                        
                                        %Find vertical position of L5-S1 marker at end of ground contact
                                        %phase
                                        L5S1_VerticalPosition_EndofContactPhase = HoppingTrialP_OriginalDataTable.RPSIS_2 (GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z )  );
    
                                        %Find maximum vertical position of L5-S1 during flight phase
                                        L5S1_MaxVerticalPosition = max( HoppingTrialP_OriginalDataTable.RPSIS_2( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z ) : GContactBeginFramesforFlightPhase_forHeight_MoCapSampHz( z ) ) );
    
                                        %Find hop height, in mm
                                        HopHeight_mm( z ) =(  L5S1_MaxVerticalPosition - L5S1_VerticalPosition_EndofContactPhase ) .* 1000;
                                        
                                    end



                                %ATx65 had poor L5-S1 tracking. Use RPSIS instead, for Involved Limb 2.0 and 2.33 Hz Hopping. Will also use for Non-Involved Limb 2.33 Hz Hopping    
                                elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{a}, 'NonInvolvedLimb' ) && strcmp( HoppingRate_ID{ b }, 'TwoPoint33Hz' )

                                    %Each iteration is 1 hop. Calculate hop height
                                    for z = 1 : length( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz )
                                        
                                        %Find vertical position of L5-S1 marker at end of ground contact
                                        %phase
                                        L5S1_VerticalPosition_EndofContactPhase = HoppingTrialP_OriginalDataTable.RPSIS_2 (GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z )  );
    
                                        %Find maximum vertical position of L5-S1 during flight phase
                                        L5S1_MaxVerticalPosition = max( HoppingTrialP_OriginalDataTable.RPSIS_2( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z ) : GContactBeginFramesforFlightPhase_forHeight_MoCapSampHz( z ) ) );
    
                                        %Find hop height, in mm
                                        HopHeight_mm( z ) =(  L5S1_MaxVerticalPosition - L5S1_VerticalPosition_EndofContactPhase ) .* 1000;
                                        
                                    end




                                else

                                    %Each iteration is 1 hop. Calculate hop height
                                    for z = 1 : length( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz )
                                        
                                        %Find vertical position of L5-S1 marker at end of ground contact
                                        %phase
                                        L5S1_VerticalPosition_EndofContactPhase = HoppingTrialP_OriginalDataTable.L5S1_2( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z )  );
    
                                        %Find maximum vertical position of L5-S1 during flight phase
                                        L5S1_MaxVerticalPosition = max( HoppingTrialP_OriginalDataTable.L5S1_2( GContactEndFramesforFlightPhase_forHeight_MoCapSampHz( z ) : GContactBeginFramesforFlightPhase_forHeight_MoCapSampHz( z ) ) );
    
                                        %Find hop height, in mm
                                        HopHeight_mm( z ) =(  L5S1_MaxVerticalPosition - L5S1_VerticalPosition_EndofContactPhase ) .* 1000;
                                        
                                    end

                                end



                                %Find average hop height
                                AverageHopHeight_mm = mean( HopHeight_mm );

                                %Find the deviation from average hop height
                                DeviationfromAverageHopHeight = AverageHopHeight_mm - HopHeight_mm;


                                %Find the GContactBegin and GContactEnd frames for calculating hopping
                                %height. The GContactEnd frames we want will end ground contact for the
                                %current hop - we can find this by adding 1 to
                                %GContactBeginDataPointsToUse_OriginalHopNumber. The GContactBegin frames
                                %we want will end the flight phase used for hop height - we can find this
                                %by adding 1 to GContactBeginDataPointsToUse_OriginalHopNumber
                                GContactBeginFrames_4HopHeight_AllHopsOnFP = OriginalHopsToUse_GContactBeginFrames( GContactBeginDataPointsToUse_OriginalHopNumber + 1 ) ;
                                GContactEndFrames_4HopHeight_AllHopsOnFP = OriginalHopsToUse_GContactEndFrames( GContactBeginDataPointsToUse_OriginalHopNumber + 1 );


                                %Find the GContactEnd frames to use for calculating hopping height,
                                %but in motion capture sampling Hz. Do this by dividing
                                %GContactEndFramesforFlightPhase_forHeight by GRF sampling Hz, then
                                %multiply by motion capture sampling Hz. Use ceil() because we can't
                                %take a partial frame (ex: if result is Frame 1024.2, we'll take
                                %Frame 1025). Then use round() to get rid of any weird number
                                %formats that might give us errors.
                                GContactEndFrames_4HopHeight_MoCapSampHz = round( ceil( ( GContactEndFrames_4HopHeight_AllHopsOnFP ./ GRFSampHz ) .* MoCapSampHz ) );
                                
                                
                                 %Find the GContactBegin frames to use for calculating hopping height,
                                %but in motion capture sampling Hz. Do this by dividing
                                %GContactBeginFramesforFlightPhase_forHeight by GRF sampling Hz, then
                                %multiply by motion capture sampling Hz. Use ceil() because we can't
                                %take a partial frame (ex: if result is Frame 1024.2, we'll take
                                %Frame 1025). Then use round() to get rid of any weird number
                                %formats that might give us errors.
                                GContactBeginFrames_4HopHeight_MoCapSampHz = round( ceil( ( GContactBeginFrames_4HopHeight_AllHopsOnFP ./ GRFSampHz ) .* MoCapSampHz ) );


                                

                                
                                                      
                                
                                
                                
%% BEGIN S LOOP - Loop Through Individual Hops

                                %Run loop once for each element within the Qth row of GContactBegin_Indices
                                for s = 1 : numel( GContactBeginFramesToUse(:,q))


                                    %First data point of the Sth hop is found by subtracting the minimum
                                    %flight phase length from the ground contact begin index
                                    FirstDataPoint_SthHop_Truncated( s ) = GContactBeginFramesToUse( s ) - MinLengthofFlightPhase_GRFSamplingHz;
                                    
                                                                 
                                    
                                    
                                    
                                    
                                    
                                    
                                    %Create a vector containing all indices for the Sth hop, from the
                                    %beginning of one flight phase and the beginning of the next. Subtract
                                    %one from the GContactEnd frame number since the frame number is the
                                    %first frame of flight phase. Want to end at the last frame of contact
                                    %phase. Need to subtract 1 from the Zth
                                    %GContactEndPoint_ToEndGContact, because end of contact is defined as
                                    %beginning of flight phase
                                    AllIndices_SthHop_EntireHopCycle = FirstDataPoint_SthHop_Truncated( s ): ( GContactEndFramesToUse_ToEndGContact( s ) - 1);

                                    
                                    %Find the number of elements of the Sth hop.
                                    LengthofEntireHop_Truncated_GRFSamplingHz(s) = numel(AllIndices_SthHop_EntireHopCycle);
                                    
                                    
%                                     %Create a prompt so we can decide whether to continue script
%                                     %execution. Will only do this if the length of the hop cycle for
%                                     %Hop S is reasonable
%                                     ContinueScriptPrompt2 = [ ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} 'Hop# ' num2str(s) ' is ' num2str( LengthofHopCycle_SthHop(s) ) '  frames long' ];
% 
%                                     %Use inputdlg function to create a dialogue box for the prompt created above
%                                     ContinueScript2_Cell = inputdlg( [ '\fontsize{18}' ContinueScriptPrompt2  ], 'Continue Script Execution? Enter No if Length of Hop Cycle Is Unreasonable', [1 150], {'Yes'} ,CreateStruct);
% 
%                                     %If there are extreme differences
%                                     if strcmp( cell2mat( ContinueScript2_Cell ), 'No' )
% 
%                                         return
%                                         
%                                     else
%                                         
%                                         disp('Continuing On');
% 
%                                     end
                                    
                                    
                                    
                                    
                                    %Splice out the Sth hop by using the indices for the Sth hop
                                    MLGRF_IndividualHops(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s) = HoppingTrialP_OriginalDataTable.FP3(AllIndices_SthHop_EntireHopCycle);
                                    APGRF_IndividualHops(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s) = HoppingTrialP_OriginalDataTable.FP3_1(AllIndices_SthHop_EntireHopCycle);
                                    vGRF_IndividualHops(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s) = HoppingTrialP_OriginalDataTable.FP3_2(AllIndices_SthHop_EntireHopCycle);

                                    MLGRF_IndividualHops_Normalized(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s) = MLGRF_IndividualHops(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s)./ParticipantNWeight;
                                    APGRF_IndividualHops_Normalized(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s) = APGRF_IndividualHops(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s)./ParticipantNWeight;
                                    vGRF_IndividualHops_Normalized(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s) = vGRF_IndividualHops(1:LengthofEntireHop_Truncated_GRFSamplingHz(s),s)./ParticipantNWeight;
                                    

                                    

                                    %Create a vector containing all indices for the Sth hop, from the
                                    %beginning of one flight phase and the beginning of the next. Subtract
                                    %one from the GContactEnd frame number since the frame number is the
                                    %first frame of flight phase. Want to end at the last frame of contact
                                    %phase
                                    AllIndices_SthHopContactPhase_GRF = GContactBeginFramesToUse( s ) : ( GContactEndFramesToUse_ToEndGContact( s ) - 1 );

                                    %Find the number of elements of the Sth hop contact phase.
                                    LengthofContactPhase_SthHop_GRFSampHz(s,q) = numel(AllIndices_SthHopContactPhase_GRF);


                                    %Splice out the GRF for the contact phase of the Sth hop by using the indices for the Sth hop
                                    MLGRF_IndividualHops_ContactPhase(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s) = HoppingTrialP_OriginalDataTable.FP3(AllIndices_SthHopContactPhase_GRF);
                                    APGRF_IndividualHops_ContactPhase(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s) = HoppingTrialP_OriginalDataTable.FP3_1(AllIndices_SthHopContactPhase_GRF);
                                    vGRF_IndividualHops_ContactPhase(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s) = HoppingTrialP_OriginalDataTable.FP3_2(AllIndices_SthHopContactPhase_GRF);

                                    %Normalize the GRF time series above by dividing GRF values by
                                    %the participant weight
                                    MLGRF_IndividualHops_ContactPhase_Normalized(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s) = MLGRF_IndividualHops_ContactPhase(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s)./ParticipantNWeight;
                                    APGRF_IndividualHops_ContactPhase_Normalized(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s) = APGRF_IndividualHops_ContactPhase(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s)./ParticipantNWeight;
                                    vGRF_IndividualHops_ContactPhase_Normalized(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s) = vGRF_IndividualHops_ContactPhase(1:LengthofContactPhase_SthHop_GRFSampHz(s,q),s)./ParticipantNWeight;
                                    
                                    %Store the original hops in new variables, to compare when removing
                                    %hops
                                        %Entire Hop Cycle
                                           MLGRF_OriginalHops_EntireHopCycle = MLGRF_IndividualHops;
                                           APGRF_OriginalHops_EntireHopCycle  = APGRF_IndividualHops;
                                           vGRF_OriginalHops_EntireHopCycle  = vGRF_IndividualHops;
        
                                            %Normalized vGRF
                                           MLGRF_OriginalHops_EntireHopCycle_Normalized = MLGRF_IndividualHops_Normalized;
                                           APGRF_OriginalHops_EntireHopCycle_Normalized = APGRF_IndividualHops_Normalized;
                                           vGRF_OriginalHops_EntireHopCycle_Normalized = vGRF_IndividualHops_Normalized;

                                        %Contact Phase Only
                                            %Non-normalized vGRF
                                           MLGRF_OriginalHops_ContactPhase = MLGRF_IndividualHops_ContactPhase;
                                           APGRF_OriginalHops_ContactPhase = APGRF_IndividualHops_ContactPhase;
                                           vGRF_OriginalHops_ContactPhase = vGRF_IndividualHops_ContactPhase;
        
                                            %Normalized vGRF
                                           MLGRF_OriginalHops_ContactPhase_Normalized = MLGRF_IndividualHops_ContactPhase_Normalized;
                                           APGRF_OriginalHops_ContactPhase_Normalized = APGRF_IndividualHops_ContactPhase_Normalized;
                                           vGRF_OriginalHops_ContactPhase_Normalized = vGRF_IndividualHops_ContactPhase_Normalized;
                               

                                end%END S LOOP





%% Check Splitting of vGRF into Contact Phase

                                TimeVector_GRF_EntireHop = ( 1 : size( MLGRF_IndividualHops, 1 )) ./ GRFSampHz;
                                TimeVector_GRF_ContactPhase = ( 1 : size( MLGRF_IndividualHops_ContactPhase, 1 )) ./ GRFSampHz;
                                YLabel_xBW = sprintf( 'vGRF ( %cBW )', char(215) );

                                figure('Color','#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Splitting of vGRF into Contact Phase  ' ParticipantList{ n } '  ' LimbID{a} '  '  '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} '  ' 'Hop# ' num2str(s)],'Visible','on')
                                
                                subplot(2, 2, 1)
                                plot(TimeVector_GRF_EntireHop, vGRF_IndividualHops,'LineWidth', 2)
                                title('Vertical GRF - Entire Hop Cycle','FontSize',16)
                                xlabel('Time (s)','FontSize',14)
                                ylabel('GRF (N)','FontSize',14)
                                ylim( [0 3000] )
                                legend('Location', 'bestoutside')

                                subplot(2, 2, 3)
                                plot(TimeVector_GRF_ContactPhase, vGRF_IndividualHops_ContactPhase,'LineWidth', 2)
                                title('Contact Phase Only','FontSize',16)
                                xlabel('Time (s)','FontSize',14)
                                ylabel('GRF (N)','FontSize',14)
                                ylim( [0 3000] )
                                legend('Location', 'bestoutside')

                                

                                subplot(2, 2, 2)
                                plot(TimeVector_GRF_EntireHop, vGRF_IndividualHops_Normalized,'LineWidth', 2)
                                title('Normalized Vertical GRF','FontSize',16)
                                xlabel('Time (s)','FontSize',14)
                                ylabel(YLabel_xBW,'FontSize',14)
                                legend('Location', 'bestoutside')
                                
                                subplot(2, 2, 4)
                                plot(TimeVector_GRF_ContactPhase, vGRF_IndividualHops_ContactPhase_Normalized,'LineWidth', 2)
                                title(' Contact Phase Only','FontSize',16)
                                xlabel('Time (s)','FontSize',14)
                                ylabel(YLabel_xBW,'FontSize',14)
                                legend('Location', 'bestoutside')
                               

                                savefig( [ ParticipantList{ n }, '_', 'vGRF', '_', LimbID{a} ' _ ' HoppingRate_ID{b}, '_ ', 'Hop# ', num2str(s) '.fig' ] );

                                pause


                                close all




                              






%% Plot AP and ML GRF



                                     %Create a prompt so we can decide whether to continue script
                                    %execution. Will only do this if the GRF time series look okay
                                    ContinueScriptPrompt = ['Continue Script Execution?'   ParticipantList{ n } '  ' LimbID{a} '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ] ;

                                    %Use inputdlg function to create a dialogue box for the prompt created above
                                    ContinueScript_Cell = inputdlg( [ '\fontsize{18}' ContinueScriptPrompt  ], 'Continue Script Execution? Enter No if vGRF Time Series Are Unreasonable', [1 150], {'Yes'} ,CreateStruct);

                                    %If there are extreme differences
                                    if strcmp( ContinueScript_Cell{ 1 }, 'No' )

                                        return

                                    end

                                    

                                    figure('Color','#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Splitting of AP and ML GRF  ' ParticipantList{ n } '  ' LimbID{a} '  '  '  ' HoppingRate_ID{b} '  ' HoppingTrialNumber{q} ],'Visible','on')
                                    
                                    
                                    subplot(2,2,1)
                                    plot(TimeVector_GRF_ContactPhase, MLGRF_IndividualHops_ContactPhase,'LineWidth',1.5)
                                    hold on
                                    L = line([0  max(TimeVector_GRF_ContactPhase)],[0 0]);
                                    L.LineWidth = 1.2;
                                    L.Color = 'k';
                                    hold off
                                    title('ML GRF - Contact Phase Only','FontSize',16)
                                    xlabel('Time (s)','FontSize',14)
                                    ylabel('GRF (N)','FontSize',14)
                                    legend('Location','bestoutside')

                                    subplot(2,2,2)
                                    plot(TimeVector_GRF_ContactPhase, MLGRF_IndividualHops_ContactPhase_Normalized,'LineWidth',1.5)
                                    hold on
                                    L = line([0  max(TimeVector_GRF_ContactPhase)],[0 0]);
                                    L.LineWidth = 1.2;
                                    L.Color = 'k';
                                    hold off
                                    title('Normalized ML GRF - Contact Phase Only','FontSize',16)
                                    xlabel('Time (s)','FontSize',14)
                                    ylabel('GRF (N)','FontSize',14)
                                    legend('Location','bestoutside')
                                    
                                    
                                    
                                    
                                    
                                    
                                    subplot(2,2,3)
                                    plot(TimeVector_GRF_ContactPhase, APGRF_IndividualHops_ContactPhase,'LineWidth',1.5)
                                    hold on
                                    L = line([0  max(TimeVector_GRF_ContactPhase)],[0 0]);
                                    L.LineWidth = 1.2;
                                    L.Color = 'k';
                                    hold off
                                    title('AP GRF - Contact Phase Only','FontSize',16)
                                    xlabel('Time (s)','FontSize',14)
                                    ylabel('GRF (N)','FontSize',14)
                                    legend('Location','bestoutside')
                                    
                                    subplot(2,2,4)
                                    plot(TimeVector_GRF_ContactPhase, APGRF_IndividualHops_ContactPhase_Normalized,'LineWidth',1.5)
                                    hold on
                                    L = line([0  max(TimeVector_GRF_ContactPhase)],[0 0]);
                                    L.LineWidth = 1.2;
                                    L.Color = 'k';
                                    hold off
                                    title('Normalized AP GRF - Contact Phase Only','FontSize',16)
                                    xlabel('Time (s)','FontSize',14)
                                    ylabel('GRF (N)','FontSize',14)
                                    legend('Location','bestoutside')
                                    
                                    
                                    

                                    if s < numel(GContactBeginFramesToUse(:,q))

                                        close all

                                    else

                                        pause

                                        close all

                                    end
                                    
                                    
                                    
                                    
                                   
                                
                                
                                %Convert GContactBeginFrames from GRF Samp Hz to MoCap Samp Hz by
                                %dividing by GRF Samp Hz then multiplying by MoCap Samp Hz. Use
                                %ceil() because the frame number may be a decimal. This doesn't make
                                %sense and will then need to round up to the next number. Then, use
                                %round() to get rid of any numbers that have the format of +e0X.
                                %MATLAB hates using this format for indexing.
                               GContactBeginFrames_MoCapSampHz = round( ceil( ( GContactBeginFramesToUse ./ GRFSampHz ) .* MoCapSampHz ) );
                                
                               %Convert GContactEndPoints_ToEndGContact from GRF Samp Hz to MoCap Samp Hz by
                                %dividing by GRF Samp Hz then multiplying by MoCap Samp Hz. Use
                                %ceil() because the frame number may be a decimal. This doesn't make
                                %sense and will then need to round up to the next number. Then, use
                                %round() to get rid of any numbers that have the format of +e0X.
                                %MATLAB hates using this format for indexing.
                                GContactEndPoints_ToEndGContact_MoCapSampHz = round( ceil(    ( GContactEndFramesToUse_ToEndGContact ./ GRFSampHz ) .* MoCapSampHz  )   );
                               
                               
                                %Convert GContactEndFramesforFlightPhase from GRF Samp Hz to MoCap Samp Hz by
                                %dividing by GRF Samp Hz then multiplying by MoCap Samp Hz. Use
                                %ceil() because the frame number may be a decimal. This doesn't make
                                %sense and will then need to round up to the next number. Then, use
                                %round() to get rid of any numbers that have the format of +e0X.
                                %MATLAB hates using this format for indexing.
                                GContactEndFramesforFlightPhase_MoCapSampHz = round( ceil(    ( GContactEndFramesToUse_BeginFlightPhase ./ GRFSampHz ) .* MoCapSampHz  )   )
                                
                                
                                
                                
                                
                                
                                %For beginning and end of ground contact phases in EMG data, we can
                                %use the same frame numbers in GContactBeginFrames and
                                %GContactEndPoints_ToEndGContact_MoCapSampHz. This is because EMG
                                %and GRF have same sampling rate
                                GContactBeginFrames_EMGSampHz = GContactBeginFramesToUse;

                                GContactEndPoints_ToEndGContact_EMGSampHz = GContactEndFramesToUse_ToEndGContact;
                                
                                
                                
                                %Convert FirstDataPoint_SthHop from GRF Samp Hz to MoCap Samp Hz by
                                %dividing by GRF Samp Hz then multiplying by MoCap Samp Hz. Use
                                %ceil() because the frame number may be a decimal. This doesn't make
                                %sense and will then need to round up to the next number. Then, use
                                %round() to get rid of any numbers that have the format of +e0X.
                                %MATLAB hates using this format for indexing.
                                FirstDataPoint_SthHop_Truncated_MoCapSampHz = round(   ceil(   ( FirstDataPoint_SthHop_Truncated  ./ GRFSampHz ) .* MoCapSampHz      )  );       
                                
                                
                                
                                %For FirstDataPoint_SthHop in terms of EMG sampling rate, we can
                                %just use FirstDataPoint_SthHop. This is because EMG
                                %and GRF have same sampling rate
                                FirstDataPoint_SthHop_Truncated_EMGSampHz = FirstDataPoint_SthHop_Truncated;
                                

                                
                                
                                

                                %Need to find length of flight, contact, and entire hop cycles in
                                %MoCap sampling rate
                                    %Each iteration is 1 hop. Calculate length of flight and ground
                                    %contact phases
                                for z = 1 : length( GContactBeginFrames_MoCapSampHz )

                                    %Find the nontruncated length of the Zth flight phase and store in
                                    %LengthofFlightPhase_GRFSamplingHz.
                                    LengthofFlightPhase_NonTruncated_MoCapSampHz( z ) = length( GContactEndFramesforFlightPhase_MoCapSampHz( z ) : ( GContactBeginFrames_MoCapSampHz( z ) - 1 ) ) ;
                                    
                                    %Find the length of the Zth flight phase and store in
                                    %LengthofFlightPhase_GRFSamplingHz.
                                    LengthofFlightPhase_Truncated_MoCapSampHz( z ) = length( FirstDataPoint_SthHop_Truncated_MoCapSampHz( z ) : ( GContactBeginFrames_MoCapSampHz( z ) - 1 ) ) ;
                                    
                                    %Find the length of the Zth contact phase and store in
                                    %LengthofContactPhase_GRFSamplingHz.
                                    LengthofContactPhase_MoCapSampHz( z ) = length( GContactBeginFrames_MoCapSampHz( z ) : GContactEndPoints_ToEndGContact_MoCapSampHz( z )  );
                                    
                                    %Find the length of the Zth hop cycle and store in
                                    %LengthofHop_EntireCycle
                                    LengthofEntireHop_NonTruncated_MoCapSampHz( z ) = length( GContactEndFramesforFlightPhase_MoCapSampHz( z ) :  GContactEndPoints_ToEndGContact_MoCapSampHz( z )   );
                                    
                                    %Find the length of the Zth hop cycle and store in
                                    %LengthofHop_EntireCycle
                                    LengthofEntireHop_Truncated_MoCapSampHz( z ) = length( FirstDataPoint_SthHop_Truncated_MoCapSampHz( z ) :  GContactEndPoints_ToEndGContact_MoCapSampHz( z )   );
                                    
                                end
                                


                                
                                %Find minimum length of flight phase - in MoCap Samp Hz
                                MinimumLengthofFlightPhase_MoCapSampHz = repmat( min( LengthofFlightPhase_Truncated_MoCapSampHz ), numel( LengthofFlightPhase_Truncated_MoCapSampHz ), 1 );
                                
                                
                                %%% SECTION TITLE
                                % DESCRIPTIVE TEXT



                                
        %% Store M-L GRF in Data Structure*

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'ML_GRF',HoppingRate_ID{b},HoppingTrialNumber{q},MLGRF_IndividualHops);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'ML_GRF_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},MLGRF_IndividualHops_ContactPhase);

        %                         David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
        %                             'ML_GRF_DownSampled',HoppingTrialNumber{q},MLGRF_IndividualHops_DownSampled);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'ML_GRF_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q},MLGRF_IndividualHops_Normalized);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'ML_GRF_ContactPhase_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q},MLGRF_IndividualHops_ContactPhase_Normalized);

        %                         David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
        %                             'ML_GRF_DownSampled_Normalized',HoppingTrialNumber{q},MLGRF_IndividualHops_DownSampled_Normalized);
        
        
        
        
        
        
        
        
        
        
    %% *Store A-P GRF in Data Structure*



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'AP_GRF',HoppingRate_ID{b},HoppingTrialNumber{q},APGRF_IndividualHops);


                                 David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'AP_GRF_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q},APGRF_IndividualHops_ContactPhase);

        %                         David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
        %                             'AP_GRF_DownSampled',HoppingTrialNumber{q},APGRF_IndividualHops_DownSampled);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'AP_GRF_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q},APGRF_IndividualHops_Normalized);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'AP_GRF_ContactPhase_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q},APGRF_IndividualHops_ContactPhase_Normalized);

        %                         David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
        %                             'AP_GRF_DownSampled_Normalized',HoppingTrialNumber{q},APGRF_IndividualHops_DownSampled_Normalized);

        
        
        
        
        
        
        
        
        
        
    %% *Store V GRF in Data Structure*



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'V_GRF',HoppingRate_ID{b},HoppingTrialNumber{q}, vGRF_IndividualHops);


                                 David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'V_GRF_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{q}, vGRF_IndividualHops_ContactPhase);

        %                         David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
        %                             'AP_GRF_DownSampled',HoppingTrialNumber{q},APGRF_IndividualHops_DownSampled);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'V_GRF_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q}, vGRF_IndividualHops_Normalized);

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
                                    'V_GRF_ContactPhase_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q}, vGRF_IndividualHops_ContactPhase_Normalized);

        %                         David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...
        %                             'AP_GRF_DownSampled_Normalized',HoppingTrialNumber{q},APGRF_IndividualHops_DownSampled_Normalized);

        
        
        
        

        
                                
                                
                                
                                
%% End Q Loop - for Hopping Trial Number
                            end
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                                %% Store GContactBegin and End Values

                                %Frames for beginning and end of Ground Contact, in GRF Sampling Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'BeginGroundContact_GRFFrames', GContactBeginFramesToUse);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'EndGroundContact_forContactPhase_GRFFrames', GContactEndFramesToUse_ToEndGContact);
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'EndGroundContact_forFlightPhase_GRFFrames', GContactEndFramesToUse_BeginFlightPhase);
                                
                                
                                
                                
                                
                                
                                %Frames for beginning and end of Ground Contact, in EMG Sampling Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'BeginGroundContact_EMGFrames', GContactBeginFrames_EMGSampHz);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'EndGroundContact_forContactPhase_EMGFrames', GContactEndPoints_ToEndGContact_EMGSampHz);
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'EndGroundContact_forFlightPhase_EMGFrames', GContactEndFramesToUse_BeginFlightPhase);
                                
                                
                                
                                
                                %Frames for beginning and end of Ground Contact, in EMG Sampling Hz
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'BeginGroundContact_MoCapFrames', GContactBeginFrames_MoCapSampHz);


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'EndGroundContact_forContactPhase_MoCapFrames', GContactEndPoints_ToEndGContact_MoCapSampHz);
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'EndGroundContact_forFlightPhase_MoCapFrames', GContactEndFramesforFlightPhase_MoCapSampHz);
                                
                                
                                
                                
                                
                                
                                %Frames for Beginning and End of Flight Phase, for Calculating
                                %Hopping Height                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'EndGroundContact_forHoppingHeight_MoCapFrames', GContactEndFramesforFlightPhase_forHeight_MoCapSampHz);
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'BeginGroundContact_forHoppingHeight_MoCapFrames', GContactBeginFramesforFlightPhase_forHeight_MoCapSampHz);
                                
                                
                                

                                
                                %Store the length of the flight phases, contact phase, and entire
                                %hop cycle - this is the number of frames, in GRF sampling rate
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'LengthofFlightPhase_NonTruncated_GRFSamplingHz', LengthofFlightPhase_NonTruncated_GRFSamplingHz );


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'LengthofFlightPhase_Truncated_GRFSamplingHz',LengthofFlightPhase_Truncated_GRFSamplingHz );


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'MinimumLengthofFlightPhase_GRFSamplingHz', MinLengthofFlightPhase_GRFSamplingHz );


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofContactPhase_GRFSamplingHz', LengthofContactPhase_SthHop_GRFSampHz );
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofEntireHopCycle_NonTruncated_GRFSamplingHz', LengthofEntireHop_NonTruncated_GRFSamplingHz );
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofEntireHopCycle_Truncated_GRFSamplingHz', LengthofEntireHop_Truncated_GRFSamplingHz );
                            
                                
                                
                                
                                
                                
                                
                                
                                
                                %Store the length of the flight phases, contact phase, and entire
                                %hop cycle - this is the number of frames, in EMG sampling rate
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'LengthofFlightPhase_NonTruncated_EMGSamplingHz', LengthofFlightPhase_NonTruncated_GRFSamplingHz );

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'LengthofFlightPhase_Truncated_EMGSamplingHz', LengthofFlightPhase_Truncated_GRFSamplingHz );

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'MinimumLengthofFlightPhase_EMGSamplingHz', MinLengthofFlightPhase_GRFSamplingHz );

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofContactPhase_EMGSamplingHz', LengthofContactPhase_SthHop_GRFSampHz );
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofEntireHopCycle_NonTruncated_EMGSamplingHz', LengthofEntireHop_NonTruncated_GRFSamplingHz );
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofEntireHopCycle_Truncated_EMGSamplingHz', LengthofEntireHop_Truncated_GRFSamplingHz );
                                

                                
                                
                                
                                
                                
                                
                                
                                
                                
                                %Store the length of the flight phases, contact phase, and entire
                                %hop cycle - this is the number of frames, in MoCap sampling rate
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'LengthofFlightPhase_NonTruncated_MoCapSamplingHz', LengthofFlightPhase_NonTruncated_MoCapSampHz );

          
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'LengthofFlightPhase_Truncated_MoCapSamplingHz', LengthofFlightPhase_Truncated_MoCapSampHz );

                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...
                                    HoppingRate_ID{b},'MinimumLengthofFlightPhase_MoCapSamplingHz', MinimumLengthofFlightPhase_MoCapSampHz );


                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofContactPhase_MoCapSamplingHz', LengthofContactPhase_MoCapSampHz );
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofEntireHopCycle_NonTruncated_MoCapSamplingHz', LengthofEntireHop_NonTruncated_MoCapSampHz );
                                
                                
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'LengthofEntireHopCycle_Truncated_MoCapSamplingHz', LengthofEntireHop_Truncated_MoCapSampHz );
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                %Store the first data point for the flight phase of each hop. The
                                %value stored below is in GRF sampling rate
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'FirstDataPointofSthHop_Truncated_GRFSamplingHz', FirstDataPoint_SthHop_Truncated );


                                %Store the first data point for the flight phase of each hop. The
                                %value stored below is in EMG sampling rate
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'FirstDataPointofSthHop_Truncated_EMGSamplingHz', FirstDataPoint_SthHop_Truncated_EMGSampHz );
                                
                                
                                %Store the first data point for the flight phase of each hop. The
                                %value stored below is in MoCap sampling rate
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'UseforIndexingIntoData',LimbID{a},...                                 
                                    HoppingRate_ID{b},'FirstDataPointofSthHop_Truncated_MoCapSamplingHz', FirstDataPoint_SthHop_Truncated_MoCapSampHz );
                                



  %% Save Hop Frequency and Hop Number


                                %Store the deviations from hopping rate
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...                                 
                                    HoppingRate_ID{b},'DeviationFromHopFrequency', DeviationfromHoppingRate );

                                %Store the hop numbers
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{ n },'IndividualHops',LimbID{a},...                                 
                                    HoppingRate_ID{b},'HopNumbers', GContactBeginDataPointsToUse_OriginalHopNumber );
                                
                                %Clear variables except for the ones listed below
                                clearvars -except David_DissertationDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList...
                                DataCategories_HoppingKinematicsKinetics DataCategories_IndividualHops ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz...
                                ATxParticipantMass ControlParticipantMass CreateStruct FirstTimeRunningCode ChangeVariableID_Cell GroupToProcess ParticipantToProcess LimbToProcess...
                                HoppingRateToProcess lasterror MassLog

                                clc

%% END B Loop - Hopping Rate                            

                        end%End B Loop - Hopping Rate
                
                end%End a Loop - for Limb ID
            
            end%End o Loop - for Data Category
        
        end%End n loop - for Participant ID
    
    end%End m loop - for Group ID
    
end%End l loop - for Quals vs Final Data


if isempty( lasterror )
    
    msgbox('\fontsize{18} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{18}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




%% SECTION 4 - Clear Variables

clearvars -except David_DissertationDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList...
    DataCategories_HoppingKinematicsKinetics DataCategories_IndividualHops ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz ATxParticipantMass ControlParticipantMass...
    CreateStruct FirstTimeRunningCode ChangeVariableID_Cell GroupToProcess ParticipantToProcess LimbToProcess HoppingRateToProcess FirstGContact EndFirstGContactBegin MassLog

clc

lasterror = [];


if isempty( lasterror )
    
    msgbox('\fontsize{18} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{18}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end