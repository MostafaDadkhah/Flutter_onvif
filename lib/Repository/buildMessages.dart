import 'package:xml/xml.dart';

import 'package:onvif/Model/WsUsernameToken.dart';

Function credentials(XmlBuilder b, WsUsernameToken token) {
  return () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Security',
        namespace:
            'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd',
        nest: () {
      b.namespace(
          'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
      b.attribute('mustUnderstand', '1',
          namespace: 'http://www.w3.org/2003/05/soap-envelope');
      b.element('UsernameToken',
          namespace:
              'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd',
          nest: () {
        b.namespace(
            'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
        b.element('Username',
            namespace:
                'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd',
            nest: () {
          b.namespace(
              'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
          b.text(token.username);
        });
        b.element('Password',
            namespace:
                'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd',
            nest: () {
          b.namespace(
              'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
          b.attribute('Type',
              'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest',
              namespace:
                  'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
          b.text(token.password);
        });
        b.element('Nonce',
            namespace:
                'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd',
            nest: () {
          b.namespace(
              'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
          b.attribute('EncodingType',
              'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary',
              namespace:
                  'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
          b.text(token.nonce);
        });
        b.element('Created',
            namespace:
                'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd',
            nest: () {
          b.namespace(
              'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');
          b.text(token.created);
        });
      });
    });
  };
}

String buildProbeMessage(String messageID) {
  final b = XmlBuilder(optimizeNamespaces: true);

  b.declaration();
  b.element('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope',
      nest: () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Header', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('MessageID',
          namespace: 'http://schemas.xmlsoap.org/ws/2004/08/addressing',
          nest: () {
        b.namespace('http://schemas.xmlsoap.org/ws/2004/08/addressing');
        b.text('uuid:${messageID}');
      });
      b.element('To',
          namespace: 'http://schemas.xmlsoap.org/ws/2004/08/addressing',
          nest: () {
        b.namespace('http://schemas.xmlsoap.org/ws/2004/08/addressing');
        b.attribute('mustUnderstand', 'true',
            namespace: 'http://www.w3.org/2003/05/soap-envelope');
        b.text('urn:schemas-xmlsoap-org:ws:2005:04:discovery');
      });
      b.element('Action',
          namespace: 'http://schemas.xmlsoap.org/ws/2004/08/addressing',
          nest: () {
        b.namespace('http://schemas.xmlsoap.org/ws/2004/08/addressing');
        b.attribute('mustUnderstand', 'true',
            namespace: 'http://www.w3.org/2003/05/soap-envelope');
        b.text('http://schemas.xmlsoap.org/ws/2005/04/discovery/Probe');
      });
    });
    b.element('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('Probe',
          namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery',
          nest: () {
        b.namespace('http://schemas.xmlsoap.org/ws/2005/04/discovery');
        b.element('Types',
            namespace: 'http://schemas.xmlsoap.org/ws/2005/04/discovery',
            nest: () {
          b.namespace('http://schemas.xmlsoap.org/ws/2005/04/discovery');
          b.text('dn:NetworkVideoTransmitter');
        });
      });
    });
  });

  return b.buildDocument().toXmlString(pretty: true);
}

String buildGetSystemDateAndTimeMessage() {
  final b = XmlBuilder(optimizeNamespaces: true);

  b.declaration();
  b.element('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope',
      nest: () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('GetSystemDateAndTime',
          namespace: 'http://www.onvif.org/ver10/device/wsdl', nest: () {
        b.namespace('http://www.onvif.org/ver10/device/wsdl');
      });
    });
  });

  return b.buildDocument().toXmlString(pretty: true);
}

String buildGetDeviceInformationMessage(WsUsernameToken token) {
  final b = XmlBuilder(optimizeNamespaces: true);

  b.declaration();
  b.element('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope',
      nest: () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Header',
        namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: credentials(b, token));
    b.element('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('GetDeviceInformation',
          namespace: 'http://www.onvif.org/ver10/device/wsdl', nest: () {
        b.namespace('http://www.onvif.org/ver10/device/wsdl');
      });
    });
  });

  return b.buildDocument().toXmlString(pretty: true);
}

String buildGetCapabilitiesMessage(WsUsernameToken token, String category) {
  final b = XmlBuilder(optimizeNamespaces: true);

  b.declaration();
  b.element('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope',
      nest: () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Header',
        namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: credentials(b, token));
    b.element('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('GetCapabilities',
          namespace: 'http://www.onvif.org/ver10/device/wsdl', nest: () {
        b.namespace('http://www.onvif.org/ver10/device/wsdl');
        b.element('Category',
            namespace: 'http://www.onvif.org/ver10/device/wsdl', nest: () {
          b.namespace('http://www.onvif.org/ver10/device/wsdl');
          b.text(category);
        });
      });
    });
  });

  return b.buildDocument().toXmlString(pretty: true);
}

String buildGetNetworkProtocolsMessage(WsUsernameToken token) {
  final b = XmlBuilder(optimizeNamespaces: true);

  b.declaration();
  b.element('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope',
      nest: () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Header',
        namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: credentials(b, token));
    b.element('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('GetNetworkProtocols',
          namespace: 'http://www.onvif.org/ver10/device/wsdl', nest: () {
        b.namespace('http://www.onvif.org/ver10/device/wsdl');
      });
    });
  });

  return b.buildDocument().toXmlString(pretty: true);
}

String buildGetProfilesMessages(WsUsernameToken token) {
  final b = XmlBuilder(optimizeNamespaces: true);

  b.declaration();
  b.element('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope',
      nest: () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Header',
        namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: credentials(b, token));
    b.element('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('GetProfiles',
          namespace: 'http://www.onvif.org/ver10/media/wsdl', nest: () {
        b.namespace('http://www.onvif.org/ver10/media/wsdl');
      });
    });
  });

  return b.buildDocument().toXmlString(pretty: true);
}

String buildGetStreamUriMessage(WsUsernameToken token,
    Map<String, String> streamSetup, String targetProfileToken) {
  final b = XmlBuilder(optimizeNamespaces: true);

  b.declaration();
  b.element('Envelope', namespace: 'http://www.w3.org/2003/05/soap-envelope',
      nest: () {
    b.namespace('http://www.w3.org/2003/05/soap-envelope');
    b.element('Header',
        namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: credentials(b, token));
    b.element('Body', namespace: 'http://www.w3.org/2003/05/soap-envelope',
        nest: () {
      b.namespace('http://www.w3.org/2003/05/soap-envelope');
      b.element('GetStreamUri',
          namespace: 'http://www.onvif.org/ver10/media/wsdl', nest: () {
        b.namespace('http://www.onvif.org/ver10/media/wsdl');
        b.element('StreamSetup',
            namespace: 'http://www.onvif.org/ver10/media/wsdl', nest: () {
          b.namespace('http://www.onvif.org/ver10/media/wsdl');
          b.element('Stream', namespace: 'http://www.onvif.org/ver10/schema',
              nest: () {
            b.namespace('http://www.onvif.org/ver10/schema');
            b.text(streamSetup['stream']);
          });
          b.element('Transport', namespace: 'http://www.onvif.org/ver10/schema',
              nest: () {
            b.namespace('http://www.onvif.org/ver10/schema');
            b.element('Protocol',
                namespace: 'http://www.onvif.org/ver10/schema', nest: () {
              b.namespace('http://www.onvif.org/ver10/schema');
              b.text(streamSetup['protocol']);
            });
          });
        });
        b.element('ProfileToken',
            namespace: 'http://www.onvif.org/ver10/media/wsdl', nest: () {
          b.namespace('http://www.onvif.org/ver10/media/wsdl');
          b.text(targetProfileToken);
        });
      });
    });
  });

  return b.buildDocument().toXmlString(pretty: true);
}
