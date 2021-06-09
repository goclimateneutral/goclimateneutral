import React, { Component } from 'react';

export default class Button extends Component {
  render() {
    const { status, className, children, onClick, href } = this.props;

    if (href) {
      return(
        <a className={`button ${className}`} href={href}>
          {children}
        </a>
      )
    } else {
      let statusIndicator;
      if (status === 'loading') {
        statusIndicator = (
          <span className="absolute left-1/2 top-1/2 transform -translate-x-1/2 -translate-y-1/2">
            <i class="fas fa-circle-notch fa-spin"></i>
          </span>
        )
      } else if (status === 'success') {
        statusIndicator = (
          <span className="absolute left-1/2 top-1/2 transform -translate-x-1/2 -translate-y-1/2">
            <i class="fas fa-check"></i>
          </span>
        )
      }

      return(
        <button 
          className={`button relative ${className}`}
          onClick={onClick}
        >
          <span className={`${statusIndicator ? "invisible" : ""}`}>
            {children}
          </span>
          {statusIndicator}
        </button>
      );
    }
  }
}
