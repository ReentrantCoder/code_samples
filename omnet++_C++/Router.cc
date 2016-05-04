#include "Router.h"


Define_Module(Router);

void Router::initialize()
{
	busyTime = 0;
	WATCH(busyTime);

	currentlyServing = NULL;
}

void Router::handleMessage(cMessage *msg)
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

void Router::sendMsgOnItsWay(WebRequest *msg)
{
	if ( msg -> getServed() ) {
		EV << "Forwarding message " << msg << " to proxy " << endl;
		send(msg, "proxy$o");
	} else {
		if ( uniform(0.0, 1.0) < .5 ) {
			EV << "Forwarding message " << msg << " to originA " << endl;
			send(msg, "origin$o", 0);
		} else {
			EV << "Forwarding message " << msg << " to originB " << endl;
			send(msg, "origin$o", 1);
		}
	}
}