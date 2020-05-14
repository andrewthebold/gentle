import React, { useState } from "react";
import withFirebaseAuth, {
  WrappedComponentProps,
} from "react-with-firebase-auth";
import "firebase/auth";
import ReportTable from "./ReportTable";
import RecentRequestsTable from "./RecentRequestsTable";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  NavLink,
} from "react-router-dom";

import { firebaseAppAuth } from "./firebase";
import RequestsTable from "./RequestsTable";
import Statistics from "./Statistics";
import LettersTable from "./LettersTable";
import CrisisModal from "./CrisisModal";

function App(props: WrappedComponentProps) {
  const [modalOpen, setModalOpen] = useState(false);

  const _handleLogin = () => {
    props.signInWithEmailAndPassword("<REDACTED_USERNAME>", "<REDACTED_PW>");
  };

  const _handleLogout = () => {
    props.signOut();
  };

  return (
    <>
      <CrisisModal
        isActive={modalOpen}
        closeModal={() => setModalOpen(false)}
      />
      <Router>
        <nav className="navbar is-white">
          <div className="navbar-brand">
            <div className="navbar-item is-size-5">
              <strong>Gentle [CONFIDENTIAL]</strong>
            </div>
          </div>
          <div className="navbar-end">
            <div className="navbar-item">
              <button className="button" onClick={() => setModalOpen(true)}>
                Crisis Letter
              </button>
            </div>
            <div className="navbar-item">
              {props.loading ? (
                "Loading..."
              ) : (
                <div className="buttons">
                  {props.user == null ? (
                    <button
                      className="button is-primary"
                      onClick={_handleLogin}
                    >
                      Log in
                    </button>
                  ) : (
                    <button className="button" onClick={_handleLogout}>
                      Log out
                    </button>
                  )}
                </div>
              )}
            </div>
          </div>
        </nav>
        {props.user != null ? (
          <>
            <Statistics />
            <div className="section columns">
              <aside className="menu column is-2">
                <p className="menu-label">Moderation</p>
                <ul className="menu-list">
                  <NavLink to="/" activeClassName="is-active" exact={true}>
                    Reports
                    {/* <div className="tag is-danger is-pulled-right">10+</div> */}
                  </NavLink>
                  <NavLink
                    to="/requests"
                    activeClassName="is-active"
                    exact={true}
                  >
                    Unpublished Requests
                  </NavLink>
                  <NavLink
                    to="/letters"
                    activeClassName="is-active"
                    exact={true}
                  >
                    Unpublished Letters
                  </NavLink>
                  <NavLink
                    to="/recent_requests"
                    activeClassName="is-active"
                    exact={true}
                  >
                    Recent Requests
                  </NavLink>
                </ul>
              </aside>
              <main className="column">
                <Switch>
                  <Route path="/" exact={true}>
                    <ReportTable />
                  </Route>
                  <Route path="/requests" exact={true}>
                    <RequestsTable />
                  </Route>
                  <Route path="/letters" exact={true}>
                    <LettersTable />
                  </Route>
                  <Route path="/recent_requests" exact={true}>
                    <RecentRequestsTable />
                  </Route>
                </Switch>
              </main>
            </div>
          </>
        ) : null}
      </Router>
    </>
  );
}

export default withFirebaseAuth({
  firebaseAppAuth,
})(App);
