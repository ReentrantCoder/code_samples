#include "ClientClosed.h"
#include "QueueNode.h"
#include <simtime.h>

Define_Module(ClientClosed);

void ClientClosed::initialize() 
{
   std::string OutputFile = par("OutputFile");
   output.open(OutputFile);
//output << "time, resp, proxy, router, originA, originB" << endl;
   ThinkTime = par("ThinkTime");
    
   int N = par("NumJobs");
   requests.resize(N);
   for (int i = 0; i < N; i++) {
     std::stringstream convert;
     convert << i;
     requests[i]= new WebRequest(convert.str().c_str());
     requests[i] -> setServed(false);
     requests[i]  -> setStartTime( simTime() );
     EV << "Forwarding message " << requests[i] << " to proxy " << endl;
     send(requests[i], "proxy$o");
   }
}

simtime_t ClientClosed::getUtil(const char *node) {
    return check_and_cast<QueueNode *>(getModuleByPath(node)) -> getBusy()/simTime();
}

void ClientClosed::handleMessage( cMessage *msg ) 
{

  WebRequest *req = check_and_cast<WebRequest *>(msg);

   if ( req -> getServed() ) {
     // it's a request that's finally been satisfied...
       simtime_t responseTime = simTime() - req->getStartTime();
       output << simTime() << ", " << responseTime;
       output << ", " << getUtil("^.proxy");
       output << ", " << getUtil("^.router");
       output << ", " << getUtil("^.originA");
       output << ", " << getUtil("^.originB");
       output << endl;
     // now, "think" for 250ms and then remind myself to send msg
     req -> setServed( false );
     scheduleAt(simTime() + ThinkTime, req); 
   } else {
      // this must be a "self message, so time to send out a request...
      req -> setStartTime( simTime() );
      EV << "Forwarding message " << req << " to proxy " << endl;
      send(req, "proxy$o");
   }
}
