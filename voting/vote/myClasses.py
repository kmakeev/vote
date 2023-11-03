

class RegProc(object):
    def __init__(self, isRunning=True,  isStopping=True, totalCount=0, id_registered=0):
        self.isRunning = isRunning
        self.isStopping = isStopping
        self.totalCount = totalCount
        self.id_registered = id_registered


class VoteProc(object):
    def __init__(self, isRunning=True, isStopping=True, totalCount=0, id_voting=0, id_ballot=0):
        self.isRunning = isRunning
        self.isStopping = isStopping
        self.totalCount = totalCount
        self.id_voting = id_voting
        self.id_ballot = id_ballot


class Message(object):
    def __init__(self, registrationProccess=None, votingProcess=None):
        self.registrationProccess = registrationProccess
        self.votingProcess = votingProcess