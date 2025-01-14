classdef ActivityPrecedence
    % An auxiliary class to specify precedence among Activity elements.
    %
    % Copyright (c) 2012-2022, Imperial College London
    % All rights reserved.

    properties (Constant)
        PRE_SEQ  = 'pre';
        PRE_AND = 'pre-AND';
        PRE_OR = 'pre-OR';
        POST_SEQ = 'post';
        POST_AND = 'post-AND';
        POST_OR = 'post-OR';
        POST_LOOP = 'post-LOOP';
        POST_CACHE = 'post-CACHE';

        ID_PRE_SEQ  = 1;
        ID_PRE_AND = 2;
        ID_PRE_OR = 3;
        ID_POST_SEQ = 11;
        ID_POST_AND = 12;
        ID_POST_OR = 13;
        ID_POST_LOOP = 14;
        ID_POST_CACHE = 15;
    end

    properties
        preActs;        %string array
        postActs;       %string array
        preType;        %string
        postType;       %string
        preParams;      %double array
        postParams;     %double array
    end

    methods
        %public methods, including constructor

        %constructor
        function obj = ActivityPrecedence(preActs, postActs, preType, postType, preParams, postParams)
            % OBJ = ACTIVITYPRECEDENCE(PREACTS, POSTACTS, PRETYPE, POSTTYPE, PREPARAMS, POSTPARAMS)

            if nargin<2 %~exist('preActs','var') || ~exist('postActs','var')
                line_error(mfilename,'Constructor requires to specify at least pre and post activities.');
            end

            if nargin<3 %~exist('preType','var')
                preType = ActivityPrecedence.PRE_SEQ;
            end
            if nargin<4 %~exist('postType','var')
                postType = ActivityPrecedence.POST_SEQ;
            end
            if nargin<5 %~exist('preParams','var')
                preParams = [];
            end
            if nargin<6 %~exist('postParams','var')
                postParams = [];
            end

            obj.preActs = preActs;
            obj.postActs = postActs;
            obj.preType = preType;
            obj.postType = postType;
            obj.preParams = preParams;
            obj.postParams = postParams;
        end

    end

    methods (Static)
        function ap = Serial(varargin)
            % AP = SERIAL(VARARGIN)

            ap = cell(nargin-1,1);
            for m = 1:nargin-1
                ap{m} = ActivityPrecedence.Sequence(varargin{m},varargin{m+1});
            end
        end

        function typeId = getPrecedenceId(precedence)
            % TYPEID = GETPRECEDENCEID(PRECEDENCE)
            % Classifies the activity precedence
            switch precedence
                case ActivityPrecedence.PRE_SEQ
                    typeId = ActivityPrecedence.ID_PRE_SEQ;
                case ActivityPrecedence.PRE_AND
                    typeId = ActivityPrecedence.ID_PRE_AND;
                case ActivityPrecedence.PRE_OR
                    typeId = ActivityPrecedence.ID_PRE_OR;
                case ActivityPrecedence.POST_SEQ
                    typeId = ActivityPrecedence.ID_POST_SEQ;
                case ActivityPrecedence.POST_AND
                    typeId = ActivityPrecedence.ID_POST_AND;
                case ActivityPrecedence.POST_OR
                    typeId = ActivityPrecedence.ID_POST_OR;
                case ActivityPrecedence.POST_LOOP
                    typeId = ActivityPrecedence.ID_POST_LOOP;
                case ActivityPrecedence.POST_CACHE
                    typeId = ActivityPrecedence.ID_POST_CACHE;
                otherwise
                    line_error(mfilename,'Unrecognized precedence type.');
            end
        end

        function ap = Sequence(preAct, postAct)
            % AP = SEQUENCE(PREACT, POSTACT)

            if isa(preAct,'Activity')
                preAct = preAct.name;
            end
            if isa(postAct,'Activity')
                postAct = postAct.name;
            end
            ap = ActivityPrecedence({preAct},{postAct});
        end

        function ap = AndJoin(preActs, postAct, quorum)
            % AP = ANDJOIN(PREACTS, POSTACT, QUORUM)

            for a = 1:length(preActs)
                if isa(preActs{a},'Activity')
                    preActs{a} = preActs{a}.name;
                end
            end
            if isa(postAct,'Activity')
                postAct = postAct.name;
            end
            if nargin<3 %~exist('quorum','var')
                quorum = [];
            end
            ap = ActivityPrecedence(preActs,{postAct},ActivityPrecedence.PRE_AND,ActivityPrecedence.POST_SEQ,quorum,[]);
        end

        function ap = OrJoin(preActs, postAct)
            % AP = ORJOIN(PREACTS, POSTACT)

            for a = 1:length(preActs)
                if isa(preActs{a},'Activity')
                    preActs{a} = preActs{a}.name;
                end
            end
            if isa(postAct,'Activity')
                postAct = postAct.name;
            end
            ap = ActivityPrecedence(preActs,{postAct},ActivityPrecedence.PRE_OR,ActivityPrecedence.POST_SEQ);
        end

        function ap = AndFork(preAct, postActs)
            % AP = ANDFORK(PREACT, POSTACTS)

            if isa(preAct,'Activity')
                preAct = preAct.name;
            end
            for a = 1:length(postActs)
                if isa(postActs{a},'Activity')
                    postActs{a} = postActs{a}.name;
                end
            end
            ap = ActivityPrecedence({preAct},postActs,ActivityPrecedence.PRE_SEQ,ActivityPrecedence.POST_AND);
        end

        function ap = Xor(preAct, postActs, probs)
            % AP = XOR(PREACT, POSTACTS, PROBS)
            %
            % This is a pseudonym for OrFork
            ap = ActivityPrecedence.OrFork(preAct, postActs, probs);
        end

        function ap = OrFork(preAct, postActs, probs)
            % AP = ORFORK(PREACT, POSTACTS, PROBS)
            %
            % OrFork is the terminology used in LQNs for a probabilistic
            % or, where a call chooses a branch with given probability

            if isa(preAct,'Activity')
                preAct = preAct.name;
            end
            for a = 1:length(postActs)
                if isa(postActs{a},'Activity')
                    postActs{a} = postActs{a}.name;
                end
            end
            ap = ActivityPrecedence({preAct},postActs,ActivityPrecedence.PRE_SEQ,ActivityPrecedence.POST_OR,[],probs);
        end

        function ap = Loop(preAct, postActs, counts)
            % AP = LOOP(PREACT, POSTACTS, COUNTS)

            if isa(preAct,'Activity')
                preAct = preAct.name;
            end
            for a = 1:length(postActs)
                if isa(postActs{a},'Activity')
                    postActs{a} = postActs{a}.name;
                end
            end
            ap = ActivityPrecedence({preAct},postActs,ActivityPrecedence.PRE_SEQ,ActivityPrecedence.POST_LOOP,[],counts);
        end

        function ap = CacheAccess(preAct, postActs)
            % AP = ORFORK(PREACT, POSTACTS, PROBS)

            if isa(preAct,'Activity')
                preAct = preAct.name;
            end
            for a = 1:length(postActs)
                if isa(postActs{a},'Activity')
                    postActs{a} = postActs{a}.name;
                end
            end
            ap = ActivityPrecedence({preAct},postActs,ActivityPrecedence.PRE_SEQ,ActivityPrecedence.POST_CACHE);
        end
    end

end
