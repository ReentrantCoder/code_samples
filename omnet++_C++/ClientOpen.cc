#include "ClientOpen.h"
#include "QueueNode.h"
#include <simtime.h>

Define_Module(ClientOpen);

void ClientOpen::initialize() 
{
   std::string OutputFile = par("OutputFile");
   output.open(OutputFile);
    InterArrivalTime = par("InterArrivalTime");

    
    WebRequest *msg = new WebRequest("self message");
    msg -> setServed(false);
    msg -> setStartTime( simTime() );
    scheduleAt(simTime() + InterArrivalTime, msg);
}

simtime_t ClientOpen::getUtil(const char *node) {
    return check_and_cast<QueueNode *>(getModuleByPath(node)) -> getBusy()/simTime();
}

void ClientOpen::handleMessage( cMessage *msg ) 
{
    WebRequest *req = check_and_cast<WebRequest *>(msg);
    InterArrivalTime = par("InterArrivalTime");

    if ( req -> getServed() ) {
        // it's a request that's finally been satisfied...
        simtime_t responseTime = simTime() - req->getStartTime();
        output << simTime() << ", " << responseTime;
        output << ", " << getUtil("^.proxy");
        output << ", " << getUtil("^.router");
        output << ", " << getUtil("^.originA");
        output << ", " << getUtil("^.originB");
        output << endl;
        delete(req);
    } else {
        
        delete(req); // could probably re-use this
        
        // this must be a "self message, so time to send out a request...
        req = new WebRequest("request"); // generate messages for proxy...
        req -> setServed( false );
        req -> setStartTime( simTime() );
        EV << "Forwarding message " << req << " to proxy " << endl;
        send(req, "proxy$o");
        
        // now, send myself another "self message" to send next request
        req = new WebRequest("self message");
        req -> setServed( false );
        scheduleAt(simTime() + InterArrivalTime, req);
    }
}
