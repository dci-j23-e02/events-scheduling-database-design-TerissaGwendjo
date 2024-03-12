--Create Attendees table
CREATE TABLE attendees (
                        attendee_id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
                        name TEXT,
                        email TEXT,
                        preferences JSONB,
                        tickets uuid []
);

-- Insert sample records into Attendees table
INSERT INTO attendees (attendee_id, name, email, preferences, tickets)
VALUES (uuid_generate_v4(), 'Lala Ngu', 'lalangu@yahoo..com', '{"interests":["Technology", "Art"]}', '{}'),
       (uuid_generate_v4(), 'Jerry Black', 'jerry@yahoo.com', '{"interests":["Music", "Food"]}', '{}'),
       (uuid_generate_v4(), 'Fru Roland', 'roland@yahoo.com', '{"interests":["Art", "Fashion"]}', '{}'),
       (uuid_generate_v4(), 'Mary Ngongang', 'ngongang@yahoo.com', '{"interests":["Food", "Technology"]}', '{}'),
       (uuid_generate_v4(), 'Emmanuel Ebai', 'ebai@yahoo.com', '{"interests":["Fashion", "Music"]}', '{}');



-- Create Venues table
CREATE TABLE Venues (
                        venue_id UUID PRIMARY KEY,
                        name TEXT,
                        location JSONB,
                        capacity INTEGER,
                        contact_info JSONB
);

-- Insert sample records into Venues table
INSERT INTO Venues (venue_id, name, location, capacity, contact_info)
VALUES
    (uuid_generate_v4(), 'Convention Center', '{"city": "New York", "country": "USA"}', 1000, '{"phone": "+1234567890", "email": "info@conventioncenter.com"}'),
    (uuid_generate_v4(), 'Stadium', '{"city": "Berlin", "country": "Germany"}', 5000, '{"phone": "+49587654321", "email": "info@stadium.com"}'),
    (uuid_generate_v4(), 'Art Gallery', '{"city": "Hamburg", "country": "Germany"}', 300, '{"phone": "+49344556677", "email": "info@artgallery.com"}'),
    (uuid_generate_v4(), 'Exhibition Center', '{"city": "Tokyo", "country": "Japan"}', 2000, '{"phone": "+8198765432", "email": "info@exhibitioncenter.com"}'),
    (uuid_generate_v4(), 'Fashion Mall', '{"city": "Milan", "country": "Italy"}', 800, '{"phone": "+3901234567", "email": "info@fashionmall.com"}');

-- Create Organizers table
CREATE TABLE Organizers (
                            organizer_id UUID PRIMARY KEY,
                            name TEXT,
                            contact_info JSONB
);

-- Create Events table with default values for foreign keys
CREATE TABLE Events (
                        event_id UUID PRIMARY KEY,
                        title TEXT,
                        description JSONB,
                        venue_id UUID REFERENCES Venues(venue_id),
                        organizer_id UUID REFERENCES Organizers(organizer_id),
                        schedule TSRANGE
);


-- Insert sample records into Events table
INSERT INTO Events (event_id, title, description, venue_id, organizer_id, schedule)
VALUES
    (uuid_generate_v4(), 'Tech Conference', '{"topics":["AI", "Cloud"]}',
     (SELECT venue_id FROM venues WHERE name = 'Convention Center' ),
     (SELECT  organizer_id FROM organizers WHERE name = 'Tech Events LLC'),
     '[2023-10-01 09:00, 2023-10-01 17:00]'),
    (uuid_generate_v4(), 'Music Festival', '{"genres":["Rock", "Pop"]}',
     (SELECT venue_id FROM Venues WHERE name = 'Stadium'),
     (SELECT organizer_id FROM Organizers WHERE name = 'Music Festivals Inc.'),
     '[2023-08-05 12:00, 2023-08-05 23:00]'),
    (uuid_generate_v4(), 'Art Exhibition', '{"type":"Modern Art"}',
     (SELECT venue_id FROM Venues WHERE name = 'Art Gallery'),
     (SELECT organizer_id FROM Organizers WHERE name = 'Art Exhibitions Group'),
     '[2023-11-15 10:00, 2023-11-20 18:00]'),
    (uuid_generate_v4(), 'Food Expo', '{"cuisines":["Italian", "Mexican"]}',
     (SELECT venue_id FROM Venues WHERE name = 'Exhibition Center'),
     (SELECT organizer_id FROM Organizers WHERE name = 'Food Expo Organization'),
     '[2023-09-10 09:00, 2023-09-12 20:00]'),
    (uuid_generate_v4(), 'Fashion Show', '{"theme":"Spring Collection"}',
     (SELECT venue_id FROM Venues WHERE name = 'Fashion Mall'),
     (SELECT organizer_id FROM Organizers WHERE name = 'Fashion Shows Ltd.'),
     '[2023-04-25 14:00, 2023-04-25 18:00]');
--This query will insert records into the Events table using the uuid_generate_v4() function to generate UUIDs for
-- event_id. It also uses subqueries to fetch venue_id and organizer_id based on the venue and organizer names
-- specified in the query.

-- Create Event_Schedules table
CREATE TABLE Event_Schedules (
                                 schedule_id UUID PRIMARY KEY,
                                 event_id UUID REFERENCES Events(event_id),
                                 start_time TIMESTAMPTZ,
                                 end_time TIMESTAMPTZ,
                                 description TEXT
);


-- Insert sample records into Event_Schedules table
INSERT INTO Event_Schedules (schedule_id, event_id, start_time, end_time, description)
VALUES
    (uuid_generate_v4(), (SELECT event_id FROM events WHERE title = 'Tech Conference'), '2023-10-01 09:00:00', '2023-10-01 17:00:00', 'Two-day event covering latest tech trends'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Music Festival'), '2023-08-05 12:00:00', '2023-08-05 23:59:59', 'Music festival featuring popular bands'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Art Exhibition'), '2023-11-15 10:00:00', '2023-11-20 18:00:00', 'Exhibition of modern art pieces'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Food Expo'), '2023-09-10 09:00:00', '2023-09-12 20:00:00', 'International food expo showcasing various cuisines'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Fashion Show'), '2023-04-25 14:00:00', '2023-04-25 18:00:00', 'Fashion show unveiling new spring collection');


-- Create Tickets table
CREATE TABLE Tickets (
                         ticket_id UUID PRIMARY KEY,
                         event_id UUID REFERENCES Events(event_id),
                         attendee_id UUID REFERENCES Attendees(attendee_id),
                         price NUMERIC,
                         status VARCHAR(20)
);

-- Insert sample records into Tickets table
INSERT INTO Tickets (ticket_id, event_id, attendee_id, price, status)
VALUES
    (uuid_generate_v4(), (SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT attendee_id FROM attendees WHERE name = 'Lala Ngu'), 100.00, 'available'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Music Festival'), (SELECT attendee_id FROM Attendees WHERE name = 'Jerry Black'), 75.00, 'sold'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Art Exhibition'), (SELECT attendee_id FROM Attendees WHERE name = 'Fru Roland'), 50.00, 'available'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Food Expo'), (SELECT attendee_id FROM Attendees WHERE name = 'Mary Ngongang'), 120.00, 'reserved'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Fashion Show'), (SELECT attendee_id FROM Attendees WHERE name = 'Emmanuel Ebai'), 80.00, 'available');



-- Create Reviews table
CREATE TABLE Reviews (
                         review_id UUID PRIMARY KEY,
                         event_id UUID REFERENCES Events(event_id),
                         attendee_id UUID REFERENCES Attendees(attendee_id),
                         rating VARCHAR(255),
                         comment TEXT
);

-- Insert sample records into Reviews table
INSERT INTO Reviews (review_id, event_id, attendee_id, rating, comment)
VALUES
    (uuid_generate_v4(), (SELECT event_id FROM events WHERE title = 'Tech Conference'), (SELECT  attendee_id FROM attendees WHERE name = 'Lala Ngu'), 'excellent', 'Great event, learned a lot about AI and Cloud computing'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Music Festival'), (SELECT attendee_id FROM Attendees WHERE name = 'Jerry Black'), 'good', 'Enjoyed the music festival, great atmosphere and performances'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Art Exhibition'), (SELECT attendee_id FROM Attendees WHERE name = 'Fru Roland'), 'fair', 'Decent exhibition, expected more variety in artworks'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Food Expo'), (SELECT attendee_id FROM Attendees WHERE name = 'Mary Ngongang'), 'poor', 'Disorganized event, not many food choices available'),
    (uuid_generate_v4(), (SELECT event_id FROM Events WHERE title = 'Fashion Show'), (SELECT attendee_id FROM Attendees WHERE name = 'Emmanuel Ebai'), 'excellent', 'Amazing fashion show, loved the new collection');


-- Create User_Preferences table
CREATE TABLE User_Preferences (
                                  user_id UUID PRIMARY KEY REFERENCES Attendees(attendee_id),
                                  interests TEXT[],
                                  notifications_enabled BOOLEAN
);


-- Find all events happening in October 2023.
SELECT *
FROM Events
WHERE schedule && '[2023-10-01, 2023-10-31]';

-- List attendees who have 'Music' as an interest.
SELECT *
FROM Attendees
WHERE preferences->'interests' @> '["Music"]';
--OR
SELECT *
FROM Attendees
WHERE preferences->>'interests' LIKE '%Music%';

--Retrieve all venues with a capacity greater than 500.
SELECT *
FROM Venues
WHERE capacity > 500;

--Get the contact information for organizers of 'Tech Conference'.
SELECT O.contact_info
FROM Organizers O
         JOIN Events E ON O.organizer_id = E.organizer_id
WHERE E.title = 'Tech Conference';

-- Find all events with tickets still available.
SELECT *
FROM Events
WHERE event_id IN (
    SELECT event_id
    FROM Tickets
    GROUP BY event_id
    HAVING COUNT(*) < (
        SELECT capacity
        FROM Venues
        WHERE Venues.venue_id = Events.venue_id
    )
);
--OR
SELECT E.*
FROM Events E
         JOIN (
    SELECT T.event_id, COUNT(*) AS tickets_sold
    FROM Tickets T
    GROUP BY T.event_id
) AS SoldTickets ON E.event_id = SoldTickets.event_id
         JOIN Venues V ON E.venue_id = V.venue_id
WHERE SoldTickets.tickets_sold < V.capacity;

--List all reviews for a specific event, ordered by rating.
SELECT *
FROM Reviews
WHERE event_id = 'eb094db8-cbb0-4039-9cbd-ef7d3a76b852'
ORDER BY rating DESC;

--Update the schedule for an event.
UPDATE Event_Schedules
SET start_time = '2023-10-01 10:00:00', end_time = '2023-10-01 18:00:00'
WHERE event_id = 'a1b05318-20a3-4da7-8c37-50d65dcb16b6';

-- Find attendees who have enabled notifications.
SELECT *
FROM Attendees
WHERE attendee_id IN (
    SELECT user_id
    FROM User_Preferences
    WHERE notifications_enabled = true
);

-- Retrieve the total number of tickets sold for each event.
SELECT E.title, COUNT(T.ticket_id) AS tickets_sold
FROM Events E
         LEFT JOIN Tickets T ON E.event_id = T.event_id
GROUP BY E.title;


--List all events an attendee is going to, based on their ticket purchases.
SELECT E.title
FROM Events E
         JOIN Tickets T ON E.event_id = T.event_id
WHERE T.attendee_id = (SELECT attendee_id FROM Attendees WHERE name = 'Fru Roland');