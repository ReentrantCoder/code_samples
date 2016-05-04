#ifndef _QueueNode_h_
#define _QueueNode_h_

#include <stdio.h>
#include <omnetpp.h>
#include <list>
#include <cmodule.h>


class QueueNode : public cSimpleModule
{
protected:
    simtime_t busyTime;
    
protected:
    virtual void initialize() = 0;
    virtual void handleMessage(cMessage *msg) = 0;
    virtual void sendMsgOnItsWay(WebRequest *msg) = 0;
    
public:
    virtual simtime_t getBusy() { return busyTime; }
};
#endif