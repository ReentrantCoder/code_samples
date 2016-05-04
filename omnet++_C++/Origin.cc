#include "Origin.h"


Define_Module(Origin);

void Origin::initialize()
{
	busyTime = 0;
	WATCH(busyTime);

	currentlyServing = NULL;
	
}

void Origin::handleMessage(cMessage *msg)
{
	WebRequest *req = check_and_cast<WebRequest *>(msg);

	if (req == currentlyServing) {
		//
		// Self message
		//
		busyTime += serviceTime;
		currentlyServing = NULL;
		sendMsgOnItsWay(req);
	} else {
		requests.push_back(req);
	}

	if ( currentlyServing == NULL && ! requests.empty() ) {
		//
		// serve next request -- send as self-message
		//
		currentlyServing = requests.front();
		requests.pop_front();
		serviceTime = par("ServiceTime");
		EV << "Start service of " << currentlyServing << " for " << serviceTime << endl;
		scheduleAt( simTime() + serviceTime, currentlyServing);
	}
}

void Origin::sendMsgOnItsWay(WebRequest *msg)
{
	msg -> setServed(true);
	EV << "Forwarding message " << msg << " to router" << endl;
	send(msg, "router$o");
}